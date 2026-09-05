## this is the command to run the CPU
```bash

python3 memory_builder.py
iverilog -o cpu_test tb_cpu.v cpu.v register_file.v alu.v flags.v pc.v pc_update_logic.v code_memory.v data_memory.v opcode_decoder.v control_unit.v 
vvp cpu_test

```
