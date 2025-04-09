# APB-to-AHB-Bridge-Verification

#Table of Contents:
o	Introduction
o	TB Architecture 
o	Verification Plan
o	AHB Protocol
o	APB Protocol
o	AHB to APB Bridge
o	Scoreboard
o	Waveforms
o	Conclusion











#Introduction:
What is AMBA? 
•	An open-standard, on-chip interconnect specification for connecting and managing components within System-on-a-Chip (SoC) designs.
•	Enables the development of complex multi-processor systems with numerous controllers and components.
•	Widely used in various ASICs and SoCs, particularly in modern mobile devices like smartphones.
AHB (Advanced High-performance Bus):
•	High-performance, single clock-edge protocol.
•	Supports burst transfers for increased efficiency.
•	Non-tristate implementation for improved signal integrity.
•	Wide data bus configurations (up to 1024 bits) for high bandwidth.
Common Slaves: Internal memory, external memory interfaces, high-bandwidth peripherals, APB bridge.
Simple Transactions: Address phase followed by data phase (typically two bus cycles).
APB (Advanced Peripheral Bus):
•	Designed for: Low-bandwidth control accesses to peripherals (e.g., Timers, UART, GPIO).
•	Characteristics: 
•	Reduced signal complexity compared to AHB.
•	Optimized for low-frequency systems and minimal power consumption. 32-bit data width.

#Objective:
This project deals with the class based verification of bridge between high speed AMBA AHB(Advanced High Performance bus) and low-power AMBA APB (Advanced Peripheral Bus) in UVM.

#TB Architecture:








#Verification Plan:
AHB Signals:
Signal Name	Source	Description
HCLK
Bus clock	Clock Source	This clock times all bus transfers. All signal timings are related to the rising edge of HCLK.
HRESETn 
Reset	Reset Controller	The bus reset signal is active LOW and is used to reset the system and the bus. This is the only active LOW signal.
HADDR[31:0] Address bus	Master	The 32-bit system address bus.
HTRANS[1:0] Transfer type	Master	Indicates the type of the current transfer, which can be NONSEQUENTIAL, SEQUENTIAL, IDLE or BUSY.
HWRITE
Transfer direction	Master	When HIGH this signal indicates a write transfer and when LOW a read transfer.
HSIZE[2:0]
Transfer size	Master	Indicates the size of the transfer, which is typically byte (8-bit), halfword (16-bit) or word (32-bit). The protocol allows for larger transfer sizes up to a maximum of 1024 bits.
HBURST[2:0]
Burst type	Master	Indicates if the transfer forms part of a burst. Four, eight, and sixteen beat bursts are supported and the burst may be either incrementing or wrapping.
HWDATA[31:0] Write data bus	Master	The write data bus is used to transfer data from the master to the bus slaves during write operations. A minimum data bus width of 32 bits is recommended. However, this may easily be extended to allow for higher bandwidth operation.
HRDATA[31:0]
Read data bus	Slave	The read data bus is used to transfer data from bus slaves to the bus master during read operations. A minimum data bus width of 32 bits is recommended. However, this may easily be extended to allow for higher bandwidth operation.
HREADY
Transfer done	Slave	When HIGH the HREADY signal indicates that a transfer has finished on the bus. This signal may be driven LOW to extend a transfer. Note: Slaves on the bus require HREADY as both an input and an output signal.
HRESP[1:0]
Transfer response	Slave	The transfer response provides additional information on the status of a transfer. Four different responses are provided, OKAY, ERROR, RETRY and SPLIT.

APB Signals:
Signal Name	Description
PCLK Bus Clock	This clock times all bus transfers. Both the LOW phase and HIGH phase of PCLK are used to control transfers.
PRESETn APB Reset	The bus reset signal is active LOW and is used to reset the system.
PENABLE APB Strobe	This strobe signal is used to time all accesses on the peripheral bus. The enable signal is used to indicate the second cycle of anAPB transfer. The rising edge of PENABLE occurs in the middle of the APB transfer.
PADDR[31:0] APB address bus	This is the APB address bus, which may be up to 32-bits wide and is driven by the peripheral bus bridge unit.
PWRITE APB transfer direction	When HIGH this signal indicates an APB write access and when LOW a read access.
PRDATA APB read data bus	The read data bus is driven by the selected slave during read cycles (when PWRITE is LOW). The read data bus can be up to 32-bits wide.
PWDATA APB write data bus	The write data bus is driven by the peripheral bus bridge unit during write cycles (when PWRITE is HIGH). The write data bus can be up to 32-bits wide.
PSELx APB select	A signal from the secondary decoder, within the peripheral bus bridge unit, to each peripheral bus slave x. This signal indicates that the slave device is selected and a data transfer is required. There is a PSELx signal for each bus slave.









Test Bench Components:
•	Driver
•	AHB Driver Logic
•	APB Driver Logic
•	Monitor
•	AHB Monitor Logic
•	APB Monitor Logic
•	Sequencer
•	Agent
•	Virtual Sequencer
•	Environment
•	Score Board
Test Cases:
•	Increment Burst
•	Wrap4 Burst
•	Wrap8 Burst
•	Wrap16 Burst
Coverage Metrices:
•	Verification of address alignment during burst transactions.
•	Analysis of data integrity across multi-size transfers.
•	Achieved 100% functional coverage.
•	Validated all burst types without errors.
•	Ensured compliance with AMBA protocol specifications.







AHB Protocol:
•	Central multiplexor interconnection scheme: Bus masters drive out address and control signals, arbiter selects the master and routes signals to slaves. A central decoder controls read data and response signals. 
•	Bus master access: Master asserts a request signal to the arbiter to gain bus access. 
•	Transfer initiation: Granted master drives address and control signals including transfer information (address, direction, width, burst). 
•	Data transfer: Write data bus for master to slave, read data bus for slave to master. 
•	Transfer cycle: Address and control cycle followed by data cycles. 
•	Address sampling: All slaves sample the address during the address and control cycle. 
•	\Data transfer extension: HREADY signal used for data transfer extension, inserting wait states to allow extra time for slaves.


 
AHB Block Diagram

APB Protocol:
•	Low-cost, low-power interface: Optimized for minimal power consumption and reduced complexity, suitable for low-bandwidth peripherals.
•	Unpipelined protocol: Simple and straightforward, without pipelining stages.
•	Clock-edge synchronization: All signal transitions are synchronized to the rising edge of the clock, simplifying integration.
•	Two-cycle transfer (APB2): Each transfer typically takes two clock cycles in APB2. Later versions may require more cycles.
•	State machine: IDLE (default), SETUP (select signal asserted), ENABLE (enable signal asserted).
•	Control signals: Only four control signals, keeping the interface simple.
•	Master/slave configurations: Supports both single-master and multiple-master configurations.
•	Slave behavior: Slave is non-responsive, and data is latched between clock cycles.
APB Block Diagram
AHB to APB Bridge:
•	Interface Conversion: Bridges between the high-speed AHB and the low-power APB.
•	Wait States: Inserts wait states during transfers to accommodate the APB's unpipelined nature.
•	Address Latching: Latches the address and holds it valid throughout the transfer.
•	Address Decoding: Decodes the address to generate the appropriate peripheral select signal (PSELx).
•	Data Handling: 
•	Drives data onto the APB for write transfers.
•	Drives APB data onto the AHB for read transfers.
•	Timing Control: Generates the PENABLE strobe signal for the transfer timing.
 
AHB to AOB Block Diagram



ScoreBoard:
•	The Scoreboard extends the uvm_scoreboard class.
•	It utilizes two TLM FIFOs: one for collecting data from the AHB monitor and another for data from the APB monitor.
2.Data Collection and Synchronization
•	AHB Monitor Data Handling: 
o	Data is received from the AHB monitor.
o	If Hwrite is high: 
	Hwdata and Haddr are pushed into a locally declared queue.
o	If Hwrite is low: 
	Hrdata is collected for later comparison.
•	APB Monitor Data Handling: 
o	Data is received from the APB monitor.
o	Data is simultaneously popped from the queue (populated by AHB monitor data).
o	Comparison is performed: 
	If Hwrite is high: Compare Hwdata with Pwdata and Haddr with Paddr.
	If Hwrite is low: Compare Hrdata with Prdata and Haddr with Paddr.
3. Coverage
•	A Covergroup is included to track specific signals of interest.
•	The UVM scoreboard acts as a verification component that includes checkers and verifies the design's functionality.
•	Functional coverage logic can be implemented within the scoreboard.

4. Data Comparison and Storage
•	Data from the AHB and APB monitors is broadcasted and compared within the scoreboard.
•	AHB and APB data are stored in separate analysis FIFOs.
•	The get method is used to retrieve data from the AHB and APB FIFOs.
•	Pushing AHB data into the queue ensures data synchronization between the AHB and APB data paths.
•	While checking data, the queue is popped to retrieve the corresponding AHB data for comparison.

















Waveforms:

 
Hierarchy:
 
Coverage Report:
 

Take Away :
Learnt Why AMBA protocols are required and its importance in the on-chip communication.
 Conversion between AHB to APB protocol, Importance of bridge. Sequence creation and execution of sequence as it is the important part of the project. 
Analyzing the pipelined waveforms. 
Main take away is its specification as it is the tricky part of the project.
Challenges:
Viewing the waveforms and reports through portal.
There was no such difficulty in the project but the tricky part is the specifications and analysing waveforms.
