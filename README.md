<h1> Instruções de uso: </h1>
1. Rodar o arquivo token.sol na [REMIX IDE](https://remix.ethereum.org/), tanto pelo método de copiar e colar quanto por baixar o arquivo na máquina e fazer o upload no site. </br>
2. Na aba "Deploy & Run Transaction", selecionar como ENVIRONMENT a opção "Injected Provider - Metamask". </br>
3. Conecte a carteria Metamask com a REMIX IDE. </br>
4.  A. Modificar o conteúdo entre aspas no trecho 'symbol = "DIO";' na linha 62 para alterar o **símbolo** do token; </br>
    B. Modificar o conteúdo entre aspas no trecho 'name = "DIO Coin";' na linha 63 para alterar o **nome** do token; </br>
    C. Modificar o valor numérico no trecho 'decimals = 2;' na linha 64 para alterar a **quantidade de casas decimais do token**, o limite é 18; </br>
    D.Modificar o valor numérico no trecho '_totalSupply = 100000;' na linha 65 para alterar a **quantidade total de tokens criados**; </br>
    B. Modificar as as linhas 66 e 67, no campo que contem  [YOUR_METAMASK_WALLET_ADDRESS] com o seu endereço de carteira Metamask. </br>
5. Verificar antes se possui saldo para a criação do Token na Blockchain selecionada;
6. Na aba "Solidity Compiler", pressionar a opção Compile
