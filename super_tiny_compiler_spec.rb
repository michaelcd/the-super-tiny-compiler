require 'rspec'
require_relative 'super_tiny_compiler.rb'

describe 'Ruby Compiler' do
  input = '(add 2 (subtract 4 2))'
  output = 'add(2, subtract(4, 2));'

  tokens = [
    { type: 'paren',  value: '(' },
    { type: 'name',   value: 'add' },
    { type: 'number', value: '2' },
    { type: 'paren',  value: '(' },
    { type: 'name',   value: 'subtract' },
    { type: 'number', value: '4' },
    { type: 'number', value: '2' },
    { type: 'paren',  value: ')' },
    { type: 'paren',  value: ')' }
  ]

  ast = {
    type: 'Program',
    body: [{
      type: 'CallExpression',
      name: 'add',
      params: [{
        type: 'NumberLiteral',
        value: '2'
      }, {
        type: 'CallExpression',
        name: 'subtract',
        params: [{
          type: 'NumberLiteral',
          value: '4'
        }, {
          type: 'NumberLiteral',
          value: '2'
        }]
      }]
    }]
  }

  newAst = {
    type: 'Program',
    body: [{
      type: 'ExpressionStatement',
      expression: {
        type: 'CallExpression',
        callee: {
          type: 'Identifier',
          name: 'add'
        },
        arguments: [{
          type: 'NumberLiteral',
          value: '2'
        }, {
          type: 'CallExpression',
          callee: {
            type: 'Identifier',
            name: 'subtract'
          },
          arguments: [{
            type: 'NumberLiteral',
            value: '4'
          }, {
            type: 'NumberLiteral',
            value: '2'
          }]
        }]
      }
    }]
  }

  it 'tokenizer should return the correct tokens array' do
    expect(tokenizer(input)).to eq(tokens)
  end

  it 'parser should return the correct abstract syntax tree' do
    expect(parser(tokens)).to eq(ast)
  end

  it 'transformer should correctly transform the AST' do
    expect(transformer(ast)).to eq(newAst)
  end

  it 'codeGenerator should return the correct string of code' do
    expect(codeGenerator(newAst)).to eq(output)
  end

  it 'compiler should take string input and return string output' do
    expect(compiler(input)).to eq(output)
  end
end
