pragma solidity ^0.4.24;
 
// Interface Safe Math - Implementa funções matemáticas seguras para evitar overflow e underflow
contract SafeMath {
 
    // Função para adição segura
    function safeAdd(uint a, uint b) public pure returns (uint c) {
        c = a + b;
        require(c >= a); // Garante que não houve overflow
    }
 
    // Função para subtração segura
    function safeSub(uint a, uint b) public pure returns (uint c) {
        require(b <= a); // Garante que não haverá underflow
        c = a - b;
    }
 
    // Função para multiplicação segura
    function safeMul(uint a, uint b) public pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b); // Verifica overflow na multiplicação
    }
 
    // Função para divisão segura
    function safeDiv(uint a, uint b) public pure returns (uint c) {
        require(b > 0); // Garante que não haverá divisão por zero
        c = a / b;
    }
}
 
// Interface ERC20 - Define as funções padrão para um token ERC20
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
 
// Interface para receber aprovação e executar uma função em uma única chamada
contract ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
}
 
// Contrato principal do token DIOToken
contract DIOToken is ERC20Interface, SafeMath {
    string public symbol;  // Símbolo do token
    string public name;    // Nome do token
    uint8 public decimals; // Casas decimais do token
    uint public _totalSupply; // Oferta total do token
 
    // Mapas que armazenam os saldos e as permissões de gasto
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;
 
    // Construtor que define os valores iniciais do token
    constructor() public {
        symbol = "DIO";           // Define o símbolo do token
        name = "DIO Coin";        // Define o nome do token
        decimals = 2;             // Define as casas decimais
        _totalSupply = 100000;    // Define a oferta total inicial
        balances[YOUR_METAMASK_WALLET_ADDRESS] = _totalSupply; // Atribui todo o supply ao criador do contrato
        emit Transfer(address(0), YOUR_METAMASK_WALLET_ADDRESS, _totalSupply); // Evento de transferência inicial
    }
 
    // Retorna a oferta total de tokens em circulação, descontando o saldo do endereço zero
    function totalSupply() public constant returns (uint) {
        return _totalSupply - balances[address(0)];
    }
 
    // Retorna o saldo de um endereço específico
    function balanceOf(address tokenOwner) public constant returns (uint balance) {
        return balances[tokenOwner];
    }
 
    // Função para transferir tokens de uma conta para outra
    function transfer(address to, uint tokens) public returns (bool success) {
        balances[msg.sender] = safeSub(balances[msg.sender], tokens); // Subtrai os tokens do remetente
        balances[to] = safeAdd(balances[to], tokens);                 // Adiciona os tokens ao destinatário
        emit Transfer(msg.sender, to, tokens);                        // Emite o evento de transferência
        return true;
    }
 
    // Aprova uma conta a gastar tokens em nome do remetente
    function approve(address spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens; // Define o valor permitido
        emit Approval(msg.sender, spender, tokens); // Emite o evento de aprovação
        return true;
    }
 
    // Transfere tokens de uma conta para outra, respeitando as permissões
    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        balances[from] = safeSub(balances[from], tokens); // Subtrai os tokens do remetente
        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens); // Subtrai da permissão do gasto
        balances[to] = safeAdd(balances[to], tokens); // Adiciona os tokens ao destinatário
        emit Transfer(from, to, tokens); // Emite o evento de transferência
        return true;
    }
 
    // Retorna o número de tokens que o `spender` ainda pode gastar do `tokenOwner`
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }
 
    // Aprova e chama uma função em um único passo
    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
        allowed[msg.sender][spender] = tokens; // Define a permissão
        emit Approval(msg.sender, spender, tokens); // Emite o evento de aprovação
        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data); // Chama a função no contrato receptor
        return true;
    }
 
    // Fallback function - Não permite que o contrato receba ETH
    function () public payable {
        revert(); // Reverte a transação
    }
}
