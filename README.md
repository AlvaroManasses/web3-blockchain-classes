# Documentação do Contrato Solidity - DIOToken

## Introdução

Este contrato Solidity implementa um token ERC20 chamado **DIOToken**, utilizando a biblioteca **SafeMath** para garantir a segurança em operações matemáticas. O contrato inclui funcionalidades padrão de um token ERC20, como transferência, aprovação e consulta de saldo, além de uma função adicional para aprovar e executar uma transação em uma única chamada.

<h1> Instruções de uso: </h1>
1. Rodar o arquivo token.sol na [REMIX IDE](https://remix.ethereum.org/), tanto pelo método de copiar e colar quanto por baixar o arquivo na máquina e fazer o upload no site. </br>
2. Na aba "Deploy & Run Transaction", selecionar como ENVIRONMENT a opção "Injected Provider - Metamask". </br>
3. Conecte a carteria Metamask com a REMIX IDE. </br>
4.  A. Modificar o conteúdo entre aspas no trecho 'symbol = "DIO";' na linha 62 para alterar o **símbolo** do token; </br>
    B. Modificar o conteúdo entre aspas no trecho 'name = "DIO Coin";' na linha 63 para alterar o **nome** do token; </br>
    C. Modificar o valor numérico no trecho 'decimals = 2;' na linha 64 para alterar a **quantidade de casas decimais do token**, o limite é 18; </br>
    D.Modificar o valor numérico no trecho '_totalSupply = 100000;' na linha 65 para alterar a **quantidade total de tokens criados**; </br>
    E. Modificar as as linhas 66 e 67, no campo que contem  [YOUR_METAMASK_WALLET_ADDRESS] com o seu endereço de carteira Metamask. </br>
5. Verificar antes se possui saldo para a criação do Token na Blockchain selecionada; </br>
6. Na aba "Solidity Compiler", pressionar a opção Compile. </br>

## Funcionalidades Principais

### SafeMath
O contrato **SafeMath** define funções matemáticas seguras para prevenir problemas como overflow e underflow:

- **safeAdd**: Adição segura, garantindo que não haja overflow.
- **safeSub**: Subtração segura, prevenindo underflow.
- **safeMul**: Multiplicação segura, verificando se o resultado é correto.
- **safeDiv**: Divisão segura, garantindo que o divisor seja maior que zero.

### ERC20Interface
A interface **ERC20Interface** define as funções padrão para um token ERC20, incluindo:

- **totalSupply**: Retorna o número total de tokens em circulação.
- **balanceOf**: Consulta o saldo de uma conta específica.
- **allowance**: Verifica a quantidade de tokens que um `spender` pode gastar de uma conta específica.
- **transfer**: Transfere tokens de uma conta para outra.
- **approve**: Aprova uma conta a gastar tokens em nome do remetente.
- **transferFrom**: Transfere tokens de uma conta para outra, utilizando uma permissão pré-aprovada.

### DIOToken
O contrato principal **DIOToken** herda de **SafeMath** e implementa a interface **ERC20Interface**:

- **Construtor**: Inicializa o token com nome, símbolo, casas decimais, e oferta total. A oferta total é atribuída à carteira especificada no campo [YOUR_METAMASK_WALLET_ADDRESS].
- **transfer**: Realiza transferências de tokens entre contas.
- **approve**: Aprova um `spender` para gastar tokens em nome do remetente.
- **transferFrom**: Permite a transferência de tokens utilizando uma permissão prévia.
- **approveAndCall**: Aprova uma transação e executa uma chamada para um contrato externo em um único passo.
- **Fallback Function**: Reverte a transação caso o contrato receba ETH, prevenindo que o contrato seja usado de forma inadequada.

## Uso do Contrato

1. **Implementação**: Para utilizar este contrato, faça o deploy no Ethereum usando uma ferramenta como Remix.
2. **Aprovação e Transferência**: Utilize as funções `approve` e `transfer` para realizar transferências seguras.
3. **Integração com Outros Contratos**: A função `approveAndCall` facilita a integração com outros contratos inteligentes.

## Observações
- **Endereço da Carteira**: Substitua `[YOUR_METAMASK_WALLET_ADDRESS]` pelo endereço real da sua carteira antes de realizar o deploy.
- **Segurança**: As funções matemáticas seguras garantem que operações básicas não resultem em erros que possam comprometer a segurança do contrato.

## Código Fonte
```solidity
pragma solidity ^0.4.24;
 
//Safe Math Interface
 
contract SafeMath {
 
    function safeAdd(uint a, uint b) public pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
 
    function safeSub(uint a, uint b) public pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }
 
    function safeMul(uint a, uint b) public pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
 
    function safeDiv(uint a, uint b) public pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }
}
 
 
//ERC Token Standard #20 Interface
 
contract ERC20Interface {
    function totalSupply() public constant returns (uint);
    function balanceOf(address tokenOwner) public constant returns (uint balance);
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);
 
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}
 
 
//Contract function to receive approval and execute function in one call
 
contract ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
}
 
//Actual token contract
 
contract DIOToken is ERC20Interface, SafeMath {
    string public symbol;
    string public  name;
    uint8 public decimals;
    uint public _totalSupply;
 
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;
 
    constructor() public {
        symbol = "DIO";
        name = "DIO Coin";
        decimals = 2;
        _totalSupply = 100000;
        balances[YOUR_METAMASK_WALLET_ADDRESS] = _totalSupply; // alterar o campo [YOUR_METAMASK_WALLET_ADDRESS] com o seu endereço de carteira
        emit Transfer(address(0), YOUR_METAMASK_WALLET_ADDRESS, _totalSupply); // alterar o campo [YOUR_METAMASK_WALLET_ADDRESS] com o seu endereço de carteira
    }
 
    function totalSupply() public constant returns (uint) {
        return _totalSupply  - balances[address(0)];
    }
 
    function balanceOf(address tokenOwner) public constant returns (uint balance) {
        return balances[tokenOwner];
    }
 
    function transfer(address to, uint tokens) public returns (bool success) {
        balances[msg.sender] = safeSub(balances[msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }
 
    function approve(address spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }
 
    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        balances[from] = safeSub(balances[from], tokens);
        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(from, to, tokens);
        return true;
    }
 
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }
 
    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
        return true;
    }
 
    function () public payable {
        revert();
    }
}
"""
