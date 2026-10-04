# UART Implementation and Verification using UVM

A complete **UART (Universal Asynchronous Receiver/Transmitter)** implementation in **Verilog HDL** with a structured **SystemVerilog/UVM-based verification environment**.

The project includes modular RTL design for both **UART Transmitter (TX)** and **UART Receiver (RX)**, along with constrained-random stimulus generation, a self-checking scoreboard, functional coverage, and simulation-based verification.

---

## 📌 Project Overview

UART is a widely used asynchronous serial communication protocol in embedded systems, FPGAs, SoCs, and ASICs.

This project implements:

* UART Transmitter in Verilog HDL
* UART Receiver in Verilog HDL
* Configurable parity support
* 8-bit data transmission
* 8× receiver oversampling
* Start-bit and stop-bit checking
* Parity error detection
* SystemVerilog verification environment
* Self-checking scoreboard
* Functional coverage
* Constrained-random verification
* Simulation and waveform analysis using ModelSim/Vivado

The design is modular, parameterizable, synthesizable, and suitable for FPGA/ASIC-oriented digital design and verification workflows.

---

## ✨ Features

### UART Transmitter

* 8-bit parameterizable data width
* 200 MHz operating clock
* Active-low asynchronous reset
* LSB-first data transmission
* No parity, even parity, and odd parity modes
* `busy` handshaking signal
* Start, data, parity, and stop bit generation
* Modular FSM-based architecture

### UART Receiver

* 8× oversampling
* 3-sample majority-vote sampling
* Start-bit detection
* 8-bit data deserialization
* Even/odd parity checking
* Stop-bit error detection
* Consecutive frame handling
* Parameterizable data and prescaler widths

### Verification Environment

The SystemVerilog verification environment contains:

* Sequence Item
* Generator
* BFM Driver
* Monitor
* Scoreboard
* Functional Coverage
* Agent
* Environment
* Top-Level Testbench

The scoreboard automatically checks:

* Start bit
* Data bits
* Parity bit
* Stop bit

---

## 🏗️ Architecture

### UART Transmitter

```text
                 ┌─────────────────┐
Parallel Data ──►│ Parity Calculator│
                 └────────┬────────┘
                          │
Parallel Data ──►┌───────▼─────────┐
                 │   Serializer     │
                 └───────┬─────────┘
                         │
                 ┌───────▼─────────┐
                 │    TX FSM        │
                 └───────┬─────────┘
                         │
                 ┌───────▼─────────┐
                 │      MUX         │
                 └───────┬─────────┘
                         │
                         ▼
                     Serial TX
```

The transmitter follows:

```text
IDLE → START → DATA → PARITY → STOP → IDLE
```

The parity state is included only when parity is enabled.

---

### UART Receiver

```text
Serial RX
    │
    ▼
┌─────────────────┐
│  Start Checker  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Edge/Bit Counter│
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Data Sampling   │
│ 8× Oversampling │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Deserializer   │
└────────┬────────┘
         │
    ┌────┴─────┐
    ▼          ▼
Parity Check  Stop Check
    │          │
    └────┬─────┘
         ▼
      RX FSM
         │
         ▼
   Parallel Data
```

The receiver uses **8× oversampling** and samples three points around the centre of each bit, applying majority-vote logic for improved sampling reliability.

---

## 📡 UART Frame Format

### No Parity

```text
START | D0 D1 D2 D3 D4 D5 D6 D7 | STOP
  0   |       8 Data Bits         |  1
```

Total: **10 bits**

### Even/Odd Parity

```text
START | D0 D1 D2 D3 D4 D5 D6 D7 | PARITY | STOP
  0   |       8 Data Bits         |   P    |  1
```

Total: **11 bits**

Data is transmitted **LSB first**.

---

## ⚙️ UART Specifications

| Parameter             | Specification           |
| --------------------- | ----------------------- |
| Clock Frequency       | 200 MHz                 |
| Data Width            | 8 bits                  |
| Data Order            | LSB First               |
| Parity                | None / Even / Odd       |
| Reset                 | Active-low asynchronous |
| Receiver Oversampling | 8×                      |
| TX Idle State         | Logic 1                 |
| RX Idle State         | Logic 1                 |
| Prescale              | Parameterizable         |

---

## 📂 Project Structure

```text
UART_PROJECT/
│
├── UART_TRANSMITTER/
│   │
│   ├── rtl/
│   │   ├── mux.v
│   │   ├── parity_calc.v
│   │   ├── serializer.v
│   │   ├── tx_fsm.v
│   │   └── uart_tx.v
│   │
│   ├── sv_tb/
│   │   ├── uart_agent.sv
│   │   ├── uart_bfm.sv
│   │   ├── uart_common.sv
│   │   ├── uart_cov.sv
│   │   ├── uart_env.sv
│   │   ├── uart_gen.sv
│   │   ├── uart_intf.sv
│   │   ├── uart_mon.sv
│   │   ├── uart_sbd.sv
│   │   ├── uart_top.sv
│   │   ├── uart_tx_item.sv
│   │   └── list.sv
│   │
│   └── verilog_tb/
│       └── uart_tx_tb.v
│
├── UART_RECEIVER/
│   │
│   ├── rtl/
│   │   ├── data_sampling.v
│   │   ├── deserializer.v
│   │   ├── edge_bit_counter.v
│   │   ├── parity_check.v
│   │   ├── rx_fsm.v
│   │   ├── start_check.v
│   │   ├── stop_check.v
│   │   └── uart_rx.v
│   │
│   ├── sv_tb/
│   │   ├── uart_agent.sv
│   │   ├── uart_bfm.sv
│   │   ├── uart_common.sv
│   │   ├── uart_cov.sv
│   │   ├── uart_env.sv
│   │   ├── uart_gen.sv
│   │   ├── uart_intf.sv
│   │   ├── uart_mon.sv
│   │   ├── uart_sbd.sv
│   │   ├── uart_top.sv
│   │   ├── uart_tx_item.sv
│   │   └── list.sv
│   │
│   └── verilog_tb/
│       └── uart_rx_tb.v
│
└── README.md
```

The project report documents separate RTL and testbench directories for the transmitter and receiver subsystems.

---

## 🧪 Verification Methodology

The verification environment follows a layered SystemVerilog/UVM-style architecture:

```text
              ┌──────────────┐
              │   Generator  │
              └──────┬───────┘
                     │
                     ▼
              ┌──────────────┐
              │  BFM Driver  │
              └──────┬───────┘
                     │
                     ▼
                   DUT
                     │
                     ▼
              ┌──────────────┐
              │    Monitor   │
              └──────┬───────┘
                     │
             ┌───────┴────────┐
             ▼                ▼
       ┌───────────┐    ┌───────────┐
       │ Scoreboard│    │  Coverage  │
       └───────────┘    └───────────┘
```

### Verification Components

| Component     | Purpose                                         |
| ------------- | ----------------------------------------------- |
| Sequence Item | Defines UART transaction data and configuration |
| Generator     | Generates test transactions                     |
| BFM           | Drives serial data onto the DUT interface       |
| Monitor       | Samples DUT signals                             |
| Scoreboard    | Compares expected and received data             |
| Coverage      | Measures functional scenarios                   |
| Agent         | Groups generator, BFM, monitor and coverage     |
| Environment   | Contains verification components and scoreboard |

The report describes the generator, BFM, monitor, scoreboard, coverage collector, agent, and environment as the main verification components.

---

## 🔬 Verification Scenarios

Four parity configurations were verified:

| Test Case   | Parity Configuration               | Transactions | Result   | Errors |
| ----------- | ---------------------------------- | -----------: | -------- | -----: |
| No Parity 1 | `parity_en = 0`, `parity_type = 0` |            4 | PASS     |      0 |
| No Parity 2 | `parity_en = 0`, `parity_type = 1` |            4 | PASS     |      0 |
| Even Parity | `parity_en = 1`, `parity_type = 0` |            4 | PASS     |      0 |
| Odd Parity  | `parity_en = 1`, `parity_type = 1` |            4 | PASS     |      0 |
| **Total**   | —                                  |       **16** | **PASS** |  **0** |

All four reported verification scenarios passed with zero errors across the tested frame fields.

---

## 📊 Scoreboard Verification

The self-checking scoreboard verifies the complete UART frame.

Example checks:

```text
PASSED START : The start bit = 0
PASSED DATA  : The data matches expected data
PASSED PARITY: The parity bit matches expected parity
PASSED STOP  : The stop bit = 1
```

The reported simulation output shows successful verification of start, data, parity, and stop bits for the tested configurations.

---

## 📈 Functional Coverage

Functional coverage was implemented using SystemVerilog covergroups.

The coverage model includes:

* `valid_data` transitions
* `s_data` transitions
* Parity enable
* Parity type
* Even parity
* Odd parity

The coverage collector receives monitored transactions and samples the covergroup for each transaction.

---

## 🖥️ Simulation

The project uses **ModelSim/Vivado** for simulation and waveform analysis.

Simulation verifies:

* UART frame generation
* Serial-to-parallel conversion
* Start-bit detection
* Data transmission
* Parity generation/checking
* Stop-bit validation
* Busy/data-valid behavior
* Scoreboard matching
* Functional coverage

The project report documents transmitter and receiver simulation waveforms and ModelSim-based waveform analysis.

> **Note:** The exact simulator compilation/run commands are not specified in the project report, so they are intentionally not included here.

---

## 🛠️ Tools & Technologies

* **Verilog HDL**
* **SystemVerilog**
* **UVM-style verification methodology**
* **ModelSim**
* **Xilinx Vivado**
* RTL Design
* Finite State Machines
* Functional Verification
* Constrained-Random Verification
* Functional Coverage
* Digital Design

---

## 🎯 Learning Outcomes

Through this project, the following concepts were implemented and practiced:

* Modular RTL design
* UART protocol implementation
* FSM design
* Serial-to-parallel conversion
* Parallel-to-serial conversion
* Parity generation and checking
* Oversampling-based receiver design
* SystemVerilog testbench development
* Constrained-random verification
* Self-checking scoreboards
* Functional coverage
* Simulation waveform analysis

---

## ✅ Results

The project successfully demonstrates:

* Functional UART transmitter RTL
* Functional UART receiver RTL
* Configurable parity support
* 8× receiver oversampling
* Error detection for parity and stop bits
* Structured SystemVerilog verification environment
* Self-checking scoreboard
* Functional coverage
* **16/16 reported transactions passed**
* **0 reported errors**

The project report concludes that the design is parameterizable and synthesizable and can be applied to FPGA and ASIC integration-oriented projects.

---

## 👨‍💻 Author

**Priyanshu Kumar**

B.Tech – Computer & Communication Engineering
JK Lakshmipat University, Jaipur

**Project:** UART Implementation and Verification using UVM

**Course:** EE1231 – Digital Verification and Testing

**Supervisor:** Dr. Gaurav Mani Khanal

---

## 📄 Project Report

The complete project report contains the detailed UART theory, RTL implementation, verification methodology, simulation results, and bibliography.

---

## 📚 References

The project report references IEEE SystemVerilog standards, UART design/verification research papers, ModelSim documentation, and digital design literature.

Simulation Results of Transmitter :https://drive.google.com/file/d/1uSLhzyrSkQOC76BSGrjFN7GPY1uvPuXz/view
Simulation Result of Reciver:https://drive.google.com/file/d/1TyqJy39cPINKaFIDVvVuSGR1lt1xYdkr/view
