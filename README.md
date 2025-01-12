# riscv_cache
![image](https://github.com/user-attachments/assets/ca53c4bf-d9b6-4a93-9b8a-75b567b322a8)

The name of topic is Design and Optimization of a Two-level Cache System for RISC-V Architecture.
This repos design RV32I with detailed code using SystemVerilog.
RV32I is implemented with D-cache, I-cache and L2-cache. Cache system also begin optimized with victim cache technique.
Cache is implemented with 8-way set associative architecture. The replacement policy is LRU (least recently used) and psuedo LRU tree based.
The detail info is in Documents/Report.pdf
The structure of this repos:
  - Documents: contains some report file, block diagram, code assembly test.
  - src_pipeline_RV32I: source code for RV32I pipelined structure.
  - src_RV32I_direct_mapped: source code for RV32I has only Data cache with direct mapped structure.
  - src_RV32I_8way_set_associative: source code for RV32I has only Data cache with set associative structure (spec: 8 way).
  - src_l1_cache: source code for RV32I have Instruction cache and Data cache, two cache were designed with set associative structure (spec: 8 way).
  - src_l2_cache: source code for RV32I have 2 level cache system, contain Instruction cache (L1 i-cache), Data cache (L1 d-cache) and L2 cache (unified cache).
  - testbench: contains testbenchs for some modules.
  - benchmark: contains benchmark programs, source codes by c and assembly for testing risc-v core.
