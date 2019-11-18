----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.02.2019 18:38:24
-- Design Name: 
-- Module Name: ethernet - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;


use IEEE.NUMERIC_STD.ALL;


entity ethernet is
  Port ( 
        clk : in std_logic;
        ethernet_tdp : out std_logic;
        ethernet_tdm : out std_logic
         
   );
end ethernet;

 architecture Behavioral of ethernet is


--sending ip
SIGNAL IPsource_1 : std_logic_vector(7 downto 0) := x"8B";
SIGNAL IPsource_2 : std_logic_vector(7 downto 0) := x"B3";
SIGNAL IPsource_3 : std_logic_vector(7 downto 0) := x"79";
SIGNAL IPsource_4 : std_logic_vector(7 downto 0) := x"10";

--computer ip

SIGNAL IPdestination_1 : std_logic_vector(7 downto 0) := x"8B";
SIGNAL IPdestination_2 : std_logic_vector(7 downto 0) := x"B3";
SIGNAL IPdestination_3 : std_logic_vector(7 downto 0) := x"79";
SIGNAL IPdestination_4 : std_logic_vector(7 downto 0) := x"BA";




--computer MAC
SIGNAL PhysicalAddress_1 : std_logic_vector(7 downto 0):= x"20";
SIGNAL PhysicalAddress_2 : std_logic_vector(7 downto 0):= x"CF";
SIGNAL PhysicalAddress_3 : std_logic_vector(7 downto 0):= x"30";
SIGNAL PhysicalAddress_4 : std_logic_vector(7 downto 0):= x"85";
SIGNAL PhysicalAddress_5 : std_logic_vector(7 downto 0):= x"7B";
SIGNAL PhysicalAddress_6 : std_logic_vector(7 downto 0):= x"FC";

--counter 
signal counter : std_logic_Vector(23 downto 0);
signal start_sending : std_logic;

--ipcheksum
signal IPCheckSum_1 : std_logic_vector(31 downto 0);
signal IPCheckSum_2 : std_logic_vector(31 downto 0);
signal IPCheckSum_3 : std_logic_vector(31 downto 0);

--signals
signal ips1_temp : std_logic_vector(15 downto 0);
signal ips3_temp : std_logic_vector(15 downto 0);
signal ipdest1_temp : std_logic_vector(15 downto 0);
signal ipdest2_temp : std_logic_vector(15 downto 0);
signal rdaddress : std_logic_vector (6 downto 0);
signal pkt_data : std_logic_vector (7 downto 0);
signal Shift_Count : std_logic_vector ( 3 downto 0);
signal SendingPacket : std_logic;
signal readram : std_logic;
signal shift_data : std_logic_vector (7 downto 0);
signal CRC : std_logic_vector (31 downto 0);
signal CRC_flush : std_logic;
signal CRC_init : std_logic;
signal CRC_input : std_logic ;
signal link_pulse_count : std_logic_vector (17 downto 0);
signal link_pulse : std_logic;
signal sending_packet_data : std_logic;
signal idle_count : std_logic_vector (3 downto 0);
signal data_out : std_logic;
signal qo : std_logic;
signal qoe : std_logic;
 
begin   


ips1_temp <= ipsource_1 & "00000000";
ips3_temp <= (ipsource_3 & "00000000");
ipdest1_temp <= (ipdestination_1 & "00000000");
ipdest2_temp <= (ipdestination_3 & "00000000");
IPCheckSum_1 <= x"0000C53F" + (ips1_temp + ipsource_2 + ips3_temp + ipsource_4 + ipdest1_temp + ipdestination_2 + ipdest2_temp + ipdestination_4);
IPCheckSum_2 <= ( ipchecksum_1 and x"0000FFFF" ) + ( "0000000000000000" & ipchecksum_1(31 downto 16)  );
IPCheckSum_3 <= ( ipchecksum_2 and x"0000FFFF" ) + ( "0000000000000000" & ipchecksum_2(31 downto 16)  );


process (clk)
    begin
        if rising_edge (clk) then 
            counter <= counter + 1 ;

            if counter = 0 then 
                start_sending <= '1' ;
            else
                start_sending <= '0';
            end if;

            CASE rdaddress IS
                -- preamble
                            when x"00" => pkt_data <= "01010101";                
                            when x"01" => pkt_data <= "01010101";                
                            when x"02" => pkt_data <= "01010101";                
                            when x"03" => pkt_data <= "01010101";                
                            when x"04" => pkt_data <= "01010101";                
                            when x"05" => pkt_data <= "01010101";                
                            when x"06" => pkt_data <= "01010101";
                            when x"07" => pkt_data <= "11010101"; 
                               
                -- Ethernet header
                            when x"08" => pkt_data <= Physicaladdress_1;
                            when x"09" => pkt_data <= Physicaladdress_2;                            
                            when x"0A" => pkt_data <= Physicaladdress_3;                           
                            when x"0B" => pkt_data <= Physicaladdress_4;                            
                            when x"0C" => pkt_data <= Physicaladdress_5;
                            when x"0D" => pkt_data <= Physicaladdress_6;
                            when x"0E" => pkt_data <= x"00";
                            when x"0F" => pkt_data <= x"12"; 
                            when x"10" => pkt_data <= x"34";
                            when x"11" => pkt_data <= x"56";
                            when x"12" => pkt_data <= x"78";
                            when x"13" => pkt_data <= x"90";
                            
                            
                -- IP Header            
                               
                            when x"14" => pkt_data <= x"08";     
                            when x"15" => pkt_data <= x"00";
                            when x"16" => pkt_data <= x"45";
                            when x"17" => pkt_data <= x"00";
                            when x"18" => pkt_data <= x"00";                                                                                                                                                  
                            when x"19" => pkt_data <= x"2E";
                            when x"1A" => pkt_data <= x"00";
                            when x"1B" => pkt_data <= x"00";
                            when x"1C" => pkt_data <= x"00";
                            when x"1D" => pkt_data <= x"00";
                            when x"1E" => pkt_data <= x"80";                        
                            when x"1F" => pkt_data <= x"11";
                            when x"20" => pkt_data <= ipchecksum_3(15 downto 8);
                            when x"21" => pkt_data <= ipchecksum_3(7 downto 0);
                            when x"22" => pkt_data <= IPsource_1;     
                            when x"23" => pkt_data <= IPsource_2;     
                            when x"24" => pkt_data <= IPsource_3;     
                            when x"25" => pkt_data <= IPsource_4;                         
                            when x"26" => pkt_data <= IPdestination_1;                       
                            when x"27" => pkt_data <= IPdestination_2;                    
                            when x"28" => pkt_data <= IPdestination_3;               
                            when x"29" => pkt_data <= IPdestination_4; 
                            
                            -- UDP header 
                            when x"2A" => pkt_data <= x"04";
                            when x"2B" => pkt_data <= x"00";
                            when x"2C" => pkt_data <= x"04";
                            when x"2D" => pkt_data <= x"00";
                            when x"2E" => pkt_data <= x"00";
                            when x"2F" => pkt_data <= x"1A";                        
                            when x"30" => pkt_data <= x"00";                             
                            when x"31" => pkt_data <= x"00";

                            --data to send
                            
                            when x"32" => pkt_data <= x"00";
                            when x"33" => pkt_data <= x"01";
                            when x"34" => pkt_data <= x"02";
                            when x"35" => pkt_data <= x"03";
                            when x"36" => pkt_data <= x"04";
                            when x"37" => pkt_data <= x"05";                        
                            when x"38" => pkt_data <= x"06";                             
                            when x"39" => pkt_data <= x"07";                            
                            when x"3A" => pkt_data <= x"08";
                            when x"3B" => pkt_data <= x"09";
                            when x"3C" => pkt_data <= x"0A";
                            when x"3D" => pkt_data <= x"0B";
                            when x"3E" => pkt_data <= x"0C";
                            when x"3F" => pkt_data <= x"0D";                        
                            when x"40" => pkt_data <= x"0E";                             
                            when x"41" => pkt_data <= x"0F";
                            when x"42" => pkt_data <= x"10";
                            when x"43" => pkt_data <= x"11";
                                                                                            
                            when OTHERS =>  pkt_data <= x"00";
                
                         end case;
                         

            if (Start_Sending = '1') then 
                SendingPacket <= '1' ;
            elsif ( (Shift_Count = 14) and rdaddress = x"48" ) then 
                SendingPacket <= '0';
             end if;

            
            if (SendingPacket = '1') then
                Shift_Count <= Shift_Count + 1;
            elsif (SendingPacket = '0') then
                Shift_Count <= "1111";              
            end if;
            
 
        if (shift_count = "1111") then
            readram <= '1';
        else
            readram <= '0';
         end if;

            
            if (shift_Count = "1111") then
               if ( SendingPacket = '1') then
                    rdaddress <= rdaddress + 1;
                elsif (SendingPacket = '1') then
                    rdaddress <= "0";
                end if;
            end if;
     
            
            if (Shift_Count(0) = '1') then
              if(readram = '1') then
                shift_data <= pkt_data;
              else  
                shift_data <= '0' & shift_data(7 downto 1);
              end if; 
            end if;
       
            
            if (CRC_flush = '1') then
                CRC_flush <= sendingPacket;
            elsif (readram = '1' ) then 
                if (rdaddress = "1000100") then
                    CRC_flush <= '1';
                else 
                    CRC_flush <= '0';
                end if;
            end if;
            
       
        
             if(readram = '1') then 
                if (rdaddress = "0000111") then
                    CRC_init <= '1';
                else 
                    CRC_init <= '0';
                        
                end if;
            end if;
       
    
    if (CRC_flush= '1') then
        CRC_input <= '0';
    else 
        CRC_input <= shift_data(0) XOR CRC(31) ;
    end if;

            
           if(shift_count(0) = '1') then 
                if (CRC_init = '1') then 
                    CRC <= (others => '1' ); 
                else 
                    if(CRC_input <= '0') then 
                       CRC <= (CRC(30 downto 0) & '1') XOR "0"; 
                    else 
                       CRC <= (CRC(30 downto 0) & '1') XOR x"04C11DB7";
                    end if;
                end if;
            end if;
       


--generating negotiation NLP


            if (sendingPacket = '1') then 
                link_pulse_count <= (others => '0');
                
            else 
                link_pulse_count <= link_pulse_count + 1 ;
            end if;
        
            if(link_pulse_count(17 downto 0) = "1111111111111111" ) then
                 link_pulse <= '1';
            else
                link_pulse <= '0';
            end if;                 
       
--TP_IDL shift register and manchester encoder


            sending_packet_data <= sendingPacket;
                    
            if (sending_packet_data = '1') then 
                idle_Count <= (others => '0');
            else 
                if( not(idle_count = "1111")) then
                    idle_count <= idle_count + '1';
                end if;
            end if;
        


            if (crc_flush = '1') then
                data_out <= NOT (CRC(31));
            else 
                data_out <= shift_Data(0);
            end if;       
        
            
            if (Sending_packet_data = '1') then 
                qo <= (NOT data_out) XOR Shift_count(0);
            else 
                qo <= '1';
            end if;
       
       
       if ( idle_Count < "0110" ) then 
       qoe <= '1';
       else 
       qoe <= (sending_packet_data OR link_pulse);
       end if;
       
    
       
      if (qoe = '1') then
        Ethernet_TDp <= qo;
      else
        Ethernet_TDp <= '0';
      end if;
   
       
      if (qo = '1') then
        Ethernet_TDm <= (not qo);
      else
        Ethernet_TDm <= '0';
      end if;
    end if;
    
end process;



end Behavioral;
