----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/25/2021 11:38:22 PM
-- Design Name: 
-- Module Name: test_env - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity data_forwardig_mips is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end data_forwardig_mips;

architecture Behavioral of data_forwardig_mips is

Component generic_mpg is
    Generic (N: integer);
    Port (clk: in std_logic;
        btn: in std_logic_vector(N-1 downto 0);
        enable: out std_logic_vector(N-1 downto 0));
End component;   

Component IFC is
    Port ( clk : in STD_LOGIC;
           BranchAddress : in STD_LOGIC_VECTOR (15 downto 0);
           JumpAddress : in STD_LOGIC_VECTOR (15 downto 0);
           Jump : in STD_LOGIC;
           PCSrc : in STD_LOGIC;
           Stall: in STD_LOGIC;
           Instr : out STD_LOGIC_VECTOR (15 downto 0);
           NextInstrAddress: out STD_LOGIC_VECTOR (15 downto 0));
end component;

component ssd is
  Port (clk: in std_logic;
        digit0: in std_logic_vector(3 downto 0);
        digit1: in std_logic_vector(3 downto 0);
        digit2: in std_logic_vector(3 downto 0);
        digit3: in std_logic_vector(3 downto 0);
        cat: out std_logic_vector(6 downto 0);
        an: out std_logic_vector(3 downto 0));
End component;

component CU is
    Port ( OpCode : in STD_LOGIC_VECTOR (2 downto 0);
           RegDst : out std_logic;
           ExtOp: out std_logic;
           AluSrc: out std_logic;
           BranchEqual: out std_logic;
           BranchGreaterEqual: out std_logic;
           BranchGreater: out std_logic;
           Jump: out std_logic;
           AluOp: out std_logic_vector(2 downto 0);
           MemWrite: out std_logic;
           MemToReg: out std_logic;
           RegWrite: out std_logic);
end component;

component ID is
    Port ( clk: in std_logic;
           RegWrite : in STD_LOGIC;
           Instr: in std_logic_vector(15 downto 0);
           RegDst: in std_logic;
           ExtOp: in std_logic;
           WriteData: in std_logic_vector(15 downto 0);
           WriteAddress: in std_logic_vector(2 downto 0);
           ReadData1: out std_logic_vector(15 downto 0);
           ReadData2: out std_logic_vector(15 downto 0);
           ExtImm: out std_logic_vector(15 downto 0);
           Func: out std_logic_vector(2 downto 0);
           Sa: out std_logic;
           DecodedWriteAddress: out std_logic_vector(2 downto 0);
           ReadAddressRS: out std_logic_vector(2 downto 0);
           ReadAddressRT: out std_logic_vector(2 downto 0));
end component;

component EX is
    Port (NextInstrAddress: in std_logic_vector(15 downto 0);
           ReadData1: in std_logic_vector(15 downto 0);
           ReadData2: in std_logic_vector(15 downto 0);
           ALUSrc: in std_logic;
           ExtImm: in std_logic_vector(15 downto 0);
           Sa: in std_logic;
           ALUOp: in std_logic_vector(2 downto 0);
           Func: in std_logic_vector(2 downto 0);
           BranchAddress: out std_logic_vector(15 downto 0);
           Zero: out std_logic;
           ALURes: out std_logic_vector(15 downto 0));
end component;

component MU is
    Port ( clk: in std_logic;
           Address: in std_logic_vector(15 downto 0);
           WriteData: in std_logic_vector(15 downto 0);
           MemWrite: in std_logic;
           MemData: out std_logic_vector(15 downto 0));
end component;

component hazard_detector is
    Port ( IF_ID_OpCode : in STD_LOGIC_VECTOR(2 downto 0);
           IF_ID_rs : in STD_LOGIC_VECTOR(2 downto 0);
           IF_ID_rt : in STD_LOGIC_VECTOR(2 downto 0);
           ID_EX_OpCode: in STD_LOGIC_VECTOR(2 downto 0);
           ID_EX_RegDst: in STD_LOGIC_VECTOR(2 downto 0);
           ID_EX_flushed: in STD_LOGIC;
           EX_MEM_OpCode: in STD_LOGIC_VECTOR(2 downto 0);
           EX_MEM_RegDst: in STD_LOGIC_VECTOR(2 downto 0);
           EX_MEM_flushed: in STD_LOGIC;
           Stall: out STD_LOGIC;
           Forward_MEM_EX_RS: out STD_LOGIC;
           Forward_MEM_EX_RT: out STD_LOGIC;
           Forward_WB_MEM_RS: out STD_LOGIC;
           Forward_WB_MEM_RT: out STD_LOGIC;
           Forward_WB_EX_RS: out STD_LOGIC;
           Forward_WB_EX_RT: out STD_LOGIC);
end component;

signal mono_btns: std_logic_vector(4 downto 0);
signal instr: std_logic_vector(15 downto 0);
signal NextInstrAddress: std_logic_vector(15 downto 0);
signal to_display: std_logic_vector(15 downto 0);
signal WriteData, ReadData1, ReadData2, ExtImm, AluRes, MemData: std_logic_vector(15 downto 0);
signal ReadAddressRS, ReadAddressRT: std_logic_vector(2 downto 0);
signal RegDst, ExtOp, AluSrc, BranchEqual, BranchGreaterEqual, BranchGreater, Jump, MemWrite, MemToReg, RegWrite: std_logic := '0';
signal AluOp: std_logic_vector(2 downto 0);
signal Func: std_logic_vector(2 downto 0);
signal Sa: std_logic;
signal BranchAddress, JumpAddress: std_logic_vector(15 downto 0);
signal Zero: std_logic;
signal Branch: std_logic;
signal DecodedWriteAddress: std_logic_vector(2 downto 0);

-- Signals for Hazard Resolution
signal Stall, Forward_MEM_EX_RS, Forward_MEM_EX_RT, Forward_WB_MEM_RS, Forward_WB_MEM_RT, Forward_WB_EX_RS, Forward_WB_EX_RT: STD_LOGIC;
signal EX_resolved_ReadData1, EX_resolved_ReadData2, MU_resolved_ReadData2: STD_LOGIC_VECTOR(15 downto 0);

-- Pipeline register IF -> ID
signal IF_ID_Instr: std_logic_vector(15 downto 0);
signal IF_ID_NextInstrAddress: std_logic_vector(15 downto 0);
signal IF_ID_Flushed: std_logic;

-- Pipeline register ID -> EX
signal ID_EX_OpCode: std_logic_vector(2 downto 0);
signal ID_EX_ReadData1, ID_EX_ReadData2: std_logic_vector(15 downto 0);
signal ID_EX_Sa, ID_EX_MemToReg, ID_EX_RegWrite, ID_EX_MemWrite, ID_EX_BranchEqual, ID_EX_BranchGreaterEqual, ID_EX_BranchGreater, ID_EX_AluSrc, ID_EX_RegDst: std_logic;
signal ID_EX_AluOp : std_logic_vector(2 downto 0);
signal ID_EX_NextInstrAddress: std_logic_vector(15 downto 0);
signal ID_EX_ExtImm: std_logic_vector(15 downto 0);
signal ID_EX_Func: std_logic_vector(2 downto 0);
signal ID_EX_RegFileWriteAddress: std_logic_vector(2 downto 0);
signal ID_EX_Forward_MEM_EX_RS, ID_EX_Forward_MEM_EX_RT, ID_EX_Forward_WB_MEM_RS, ID_EX_Forward_WB_MEM_RT, ID_EX_Forward_WB_EX_RS, ID_EX_Forward_WB_EX_RT: STD_LOGIC;
signal ID_EX_Flushed: std_logic;

-- Pipeline register EX -> MU
signal EX_MU_OpCode: std_logic_vector(2 downto 0);
signal EX_MU_AluRes, EX_MU_BranchAddress, EX_MU_ReadData2: std_logic_vector(15 downto 0);
signal EX_MU_Zero: std_logic;
signal EX_MU_MemToReg, EX_MU_RegWrite, EX_MU_MemWrite, EX_MU_BranchEqual, EX_MU_BranchGreater, EX_MU_BranchGreaterEqual: std_logic;
signal EX_MU_RegFileWriteAddress: std_logic_vector(2 downto 0);
signal EX_MU_Forward_WB_MEM_RS, EX_MU_Forward_WB_MEM_RT: STD_LOGIC;
signal EX_MU_flushed: std_logic;

-- Pipeline register MU -> WB
signal MU_WB_RegWrite, MU_WB_MemToReg: std_logic;
signal MU_WB_RegFileWriteAddress: std_logic_vector(2 downto 0);
signal MU_WB_MemData, MU_WB_AluRes: std_logic_vector(15 downto 0);
signal MU_WB_flushed: std_logic;

signal internal_clk: std_logic;

begin

internal_clk <= clk;

IF_Comp: IFC port map(
                clk => internal_clk,
               BranchAddress => EX_MU_BranchAddress,
               JumpAddress => JumpAddress,
               Jump => Jump,
               PCSrc => Branch,
               Stall => Stall,
               Instr => Instr,
               NextInstrAddress => NextInstrAddress
            );
            
IF_ID_Reg: process(internal_clk)
begin
    if internal_clk'event and internal_clk = '1' then
        if Branch = '1' or Jump = '1' then
            IF_ID_Instr <= x"0000"; -- Flush --> NOP
            IF_ID_NextInstrAddress <= NextInstrAddress;
            IF_ID_flushed <= '1';
        elsif Stall='0' then
            IF_ID_Instr  <= Instr;
            IF_ID_NextInstrAddress <= NextInstrAddress;
            IF_ID_flushed <= '0';
        -- else: stall
        end if;
    end if;
end process;        
            
ID_Comp: ID port map(
               clk => internal_clk,
               RegWrite  => MU_WB_RegWrite,
               Instr => IF_ID_Instr,
               RegDst => RegDst,
               ExtOp => ExtOp,
               WriteData => WriteData,
               WriteAddress => MU_WB_RegFileWriteAddress,
               ReadData1 => ReadData1,
               ReadData2 => ReadData2,
               ExtImm => ExtImm, 
               Func => Func,
               Sa => Sa,
               DecodedWriteAddress => DecodedWriteAddress,
               ReadAddressRS => ReadAddressRS,
               ReadADdressRT => ReadAddressRT
            );
            
CU_Comp: CU port map(
               OpCode => IF_ID_Instr(15 downto 13),
               RegDst => RegDst,
               ExtOp => ExtOp,
               AluSrc => AluSrc,
               BranchEqual => BranchEqual,
               BranchGreaterEqual => BranchGreaterEqual,
               BranchGreater => BranchGreater,
               Jump => Jump,
               AluOp => AluOp,
               MemWrite => MemWrite,
               MemToReg => MemToReg,
               RegWrite => RegWrite
            );   
            
ID_EX_Reg: process(internal_clk)
begin
    if internal_clk'event and internal_clk = '1' then
        if Branch='1' or Stall='1' then 
            -- Flush --> NOP
            ID_EX_OpCode <= "111"; --jump instructions have no effect after the EX stage
            ID_EX_RegWrite <= '0';
            ID_EX_MemWrite <= '0';
            ID_EX_BranchEqual <= '0';
            ID_EX_BranchGreater <= '0';
            ID_EX_BranchGreaterEqual <= '0';
            ID_EX_RegFileWriteAddress <= "000";
            ID_EX_flushed <= '1';
        else
            ID_EX_OpCode <= IF_ID_Instr(15 downto 13);
            ID_EX_RegWrite <= RegWrite;
            ID_EX_MemWrite <= MemWrite;
            ID_EX_BranchEqual <= BranchEqual;
            ID_EX_BranchGreater <= BranchGreater;
            ID_EX_BranchGreaterEqual <= BranchGreaterEqual;
            ID_EX_RegFileWriteAddress <= DecodedWriteAddress;
            ID_EX_flushed <= IF_ID_flushed;
        end if;
        ID_EX_MemToReg <= MemToReg;
        ID_Ex_AluSrc <= AluSrc;
        ID_EX_AluOp <= AluOp;
        ID_EX_ReadData1 <= ReadData1;
        ID_EX_ReadData2 <= ReadData2;
        ID_EX_NextInstrAddress <= IF_ID_NextInstrAddress;
        ID_EX_ExtImm <= ExtImm;
        ID_EX_Func <= Func;
        ID_EX_Sa <= Sa;
        ID_EX_Forward_MEM_EX_RS <= Forward_MEM_EX_RS; 
        ID_EX_Forward_MEM_EX_RT <= Forward_MEM_EX_RT;
        ID_EX_Forward_WB_MEM_RS <= Forward_WB_MEM_RS; 
        ID_EX_Forward_WB_MEM_RT <= Forward_WB_MEM_RT; 
        ID_EX_Forward_WB_EX_RS <= Forward_WB_EX_RS; 
        ID_EX_Forward_WB_EX_RT <= Forward_WB_EX_RT;
    end if;
end process;   
            
EX_Comp: EX port map(
               NextInstrAddress => ID_EX_NextInstrAddress,
               ReadData1 => EX_resolved_ReadData1,
               ReadData2 => EX_resolved_ReadData2,
               ALUSrc => ID_EX_AluSrc,
               ExtImm => ID_EX_ExtImm,
               Sa => ID_EX_Sa,
               ALUOp => ID_EX_AluOp,
               Func => ID_EX_Func,
               BranchAddress => BranchAddress,
               Zero => Zero,
               ALURes => AluRes);

EX_MU_Reg: process(internal_clk)
begin
    if internal_clk'event and internal_clk = '1' then
        if Branch='1' then
            -- flush
            EX_MU_OpCode <= "111"; --jump instructions have no effect after the EX stage
            EX_MU_RegWrite <= '0';
            EX_MU_MemWrite <= '0';
            EX_MU_flushed <= '1';
        else
            EX_MU_OpCode <= ID_EX_OpCode;
            EX_MU_RegWrite <= ID_EX_RegWrite;
            EX_MU_MemWrite <= ID_EX_MemWrite;
            EX_MU_flushed <= ID_EX_flushed;
        end if;
        EX_MU_AluRes <= AluRes;
        EX_MU_ReadData2 <= EX_resolved_ReadData2;
        EX_MU_Zero <= Zero;
        EX_MU_BranchAddress <= BranchAddress;
        EX_MU_MemToReg <= ID_EX_MemToReg;
        EX_MU_BranchEqual <= ID_EX_BranchEqual;
        EX_MU_BranchGreater <= ID_EX_BranchGreater;
        EX_MU_BranchGreaterEqual <= ID_EX_BranchGreaterEqual;
        EX_MU_RegFileWriteAddress <= ID_EX_RegFileWriteAddress;
        EX_MU_Forward_WB_MEM_RS <= ID_EX_Forward_WB_MEM_RS; 
        EX_MU_Forward_WB_MEM_RT <= ID_EX_Forward_WB_MEM_RT;
    end if;
end process;              
             
MU_Comp: MU port map( 
            clk => internal_clk,
           Address => EX_MU_AluRes,
           WriteData => MU_resolved_ReadData2,
           MemWrite => EX_MU_MemWrite,
           MemData => MemData);
           
MU_WB_Reg: process(internal_clk)
begin
    if internal_clk'event and internal_clk = '1' then
        MU_WB_RegWrite <= EX_MU_RegWrite;
        MU_WB_RegFileWriteAddress <= EX_MU_RegFileWriteAddress;
        MU_WB_MemData <= MemData;
        MU_WB_AluRes <= EX_MU_AluRes;
        MU_WB_MemToReg <= EX_MU_MemToReg;
        MU_WB_flushed <= EX_MU_flushed;
    end if;
end process;    

HazardDetector: hazard_detector port map( 
           IF_ID_OpCode => IF_ID_Instr(15 downto 13),
           IF_ID_rs => ReadAddressRS,
           IF_ID_rt => ReadAddressRT,
           ID_EX_OpCode => ID_EX_OpCode,
           ID_EX_RegDst => ID_EX_RegFileWriteAddress,
           ID_EX_flushed => ID_EX_flushed,
           EX_MEM_OpCode => EX_MU_OpCode,
           EX_MEM_RegDst => EX_MU_RegFileWriteAddress,
           EX_MEM_flushed => EX_MU_flushed,
           Stall => Stall,
           Forward_MEM_EX_RS => Forward_MEM_EX_RS,
           Forward_MEM_EX_RT => Forward_MEM_EX_RT,
           Forward_WB_MEM_RS => Forward_WB_MEM_RS,
           Forward_WB_MEM_RT => Forward_WB_MEM_RT,
           Forward_WB_EX_RS => Forward_WB_EX_RS,
           Forward_WB_EX_RT => Forward_WB_EX_RT);
              
MonoPulseGenerator: generic_mpg
        generic map(N => 5)
        port map(clk => clk, btn => btn, enable => mono_btns);
 
 ------------------------------------------------------------write-back unit
 WriteData <= MU_WB_AluRes when MU_WB_MemToReg = '0' else MU_WB_MemData;
 
 ---------------------------------------------------------- jump and branch control
 JumpAddress <= IF_ID_NextInstrAddress(15 downto 13) & IF_ID_Instr(12 downto 0);
 Branch_Ctrl: process(EX_MU_BranchEqual, EX_MU_BranchGreaterEqual, EX_MU_BranchGreater, EX_MU_Zero, EX_MU_AluRes) 
 begin
    Branch <= '0';
    if (EX_MU_BranchEqual = '1' or EX_MU_BranchGreaterEqual = '1') and EX_MU_Zero = '1' then
        Branch <= '1';
    elsif EX_MU_BranchGreaterEqual = '1' and EX_MU_AluRes(15) = '0' then
        Branch <= '1';
    elsif EX_MU_BranchGreater = '1' and EX_MU_AluRes(15) = '0' and EX_MU_Zero /= '1' then
        Branch <= '1';
    end if;
 end process;    
 
 --------------------------------------------------------- hazard resolution
 
 EX_resolved_ReadData1 <= EX_MU_AluRes when ID_EX_Forward_MEM_EX_RS = '1' else
                          MU_WB_AluRes when ID_EX_Forward_WB_EX_RS = '1' and MU_WB_MemToReg = '0' else
                          MU_WB_MemData when ID_EX_Forward_WB_EX_RS = '1' and MU_WB_MemToReg = '1' else
                          ID_EX_ReadData1;
                          
 EX_resolved_ReadData2 <= EX_MU_AluRes when ID_EX_Forward_MEM_EX_RT = '1' else
                          MU_WB_AluRes when ID_EX_Forward_WB_EX_RT = '1' and MU_WB_MemToReg = '0' else
                          MU_WB_MemData when ID_EX_Forward_WB_EX_RT = '1' and MU_WB_MemToReg = '1' else
                          ID_EX_ReadData2;
                          
 MU_resolved_ReadData2 <= MU_WB_AluRes when EX_MU_Forward_WB_MEM_RT = '1' and MU_WB_MemToReg = '0' else
                          MU_WB_MemData when EX_MU_Forward_WB_MEM_RT = '1' and MU_WB_MemToReg = '1' else
                          EX_MU_ReadData2;
                          
 ---------------------display--------------------------
 
 SevenSegmentDisplay: ssd port map(clk => clk,
                                  digit0 => to_display(3 downto 0), digit1 => to_display(7 downto 4), digit2 => to_display(11 downto 8), digit3 => to_display(15 downto 12),
                                  cat => cat, an => an);
                                                 
 DISPLAY_MUX: process(sw(7 downto 5), NextInstrAddress, instr)
 begin
    case sw(7 downto 5) is
        when "000" => to_display <= Instr;
        when "001" => to_display <= NextInstrAddress;
        when "010" => to_display <= ReadData1;
        when "011" => to_display <= ReadData2;
        when "100" => to_display <= ExtImm;
        when "101" => to_display <= AluRes;
        when "110" => to_display <= MemData;
        when "111" => to_display <= WriteData;
        when others => to_display <= x"FFFF";
    end case;
 end process;
 
 led(0) <= Jump;
 led(1) <= Branch;
 led(2) <= RegDst;
 led(3) <= ExtOp;
 led(4) <= ALUSrc;
 led(5) <= BranchEqual;
 led(6) <= BranchGreaterEqual;
 led(7) <= BranchGreater;
 led(8) <= MemWrite;
 led(9) <= Stall;
 led(12 downto 10) <= AluOp;
 led(15 downto 13) <= Func;
 
end Behavioral;
