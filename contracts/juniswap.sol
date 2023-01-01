pragma solidity 0.8.11;
// SPDX-License-Identifier: UNLICENSED

interface IERC20 {
    function decimals() external view returns (uint8);
    //function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    //function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function mint(address account, uint256 amount) external;
    function burn(address account, uint256 amount) external;
}

contract JuniSwap {
    address public admin;
    IERC20 public USDC = IERC20(0x17D484e98402321551d39CF4A0050B18a343780F);
    IERC20 public USDT = IERC20(0x13512979ADE267AB5100878E2e0f485B568328a4);
    address[] public tokens = [0x17D484e98402321551d39CF4A0050B18a343780F, 0x13512979ADE267AB5100878E2e0f485B568328a4];
    IERC20 public JUSD;

    modifier onlyAdmin {
        require(admin == msg.sender, "JuniSwap: caller is not admin");
        _;
    }
    
    constructor(
        address _jusd
    ) {
        JUSD = IERC20(_jusd);
        admin = msg.sender;
    }

    // test functions
    function testTransfer() external {
        USDC.transferFrom(msg.sender, address(this), 1);
    }

    function testDecimals() external view returns(uint8) {
        return JUSD.decimals();
    }

    // actual functions

    function addToken(address _token) external onlyAdmin {
        tokens.push(_token);
    }

    function removeToken(address _token) external onlyAdmin {
        uint256 length = tokens.length;
        for (uint256 i = 0; i < length; i++) {
            if(tokens[i] == _token){
                tokens[i] = tokens[length - 1];
                tokens.pop();
                break;
            }
        }
    }

    function swap(address _input, address _output, uint256 _amountIn) external {
        //require(isAdded(_input), "JuniSwap: token not added");
        IERC20 inputToken = IERC20(_input);
        IERC20 outputToken = IERC20(_output);
        uint8 decimalsIn = inputToken.decimals();
        uint8 decimalsOut = outputToken.decimals();
        uint256 amountOut;
        if (decimalsOut > decimalsIn) {
            amountOut = _amountIn * 10 ** (decimalsOut - decimalsIn);
        } else {
            amountOut = _amountIn / 10 ** (decimalsIn - decimalsOut);
        }
        inputToken.transferFrom(msg.sender, address(this), _amountIn);
        outputToken.transfer(msg.sender, amountOut);
    }

    function isAdded(address _token) public view returns (bool) { //make internal later
        uint256 length = tokens.length;
        for (uint256 i = 0; i < length; i++) {
            if(tokens[i] == _token){
                return true;
            }
        }
        return false;
    }

    // gas optimized functions

    function depositUSDC(uint256 _amount) external {
        USDC.transferFrom(msg.sender, address(this), _amount);
        JUSD.mint(msg.sender, _amount*10**12);
    }
    function depositUSDT(uint256 _amount) external {
        USDT.transferFrom(msg.sender, address(this), _amount);
        JUSD.mint(msg.sender, _amount*10**12);
    }
    function withdrawUSDC(uint256 _amount) external {
        JUSD.burn(msg.sender, _amount*10**12);
        USDT.transfer(msg.sender, _amount);
    }
    function withdrawUSDT(uint256 _amount) external {
        JUSD.burn(msg.sender, _amount*10**12);
        USDT.transfer(msg.sender, _amount);
    }
    function swapUSDCToUSDT(uint256 _amount) external {
        USDC.transferFrom(msg.sender, address(this), _amount);
        USDT.transfer(msg.sender, _amount);
    }
    function swapUSDTToUSDC(uint256 _amount) external {
        USDT.transferFrom(msg.sender, address(this), _amount);
        USDC.transfer(msg.sender, _amount);
    }
}