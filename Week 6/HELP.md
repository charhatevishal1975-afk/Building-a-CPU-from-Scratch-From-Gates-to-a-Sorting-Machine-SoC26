## this is the command to run the CPU
```bash

python3 memory_builder.py
iverilog -o cpu_test tb_cpu.v opcode_decoder.v pc.v code_memory.v instruction_register.v register_file.v pipeline_register.v alu.v alu_out_register.v flags.v data_memory.v pc_update_logic.v multicycle_control.v multicycle_cpu.v 
vvp cpu_test

```
