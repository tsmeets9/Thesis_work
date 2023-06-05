"""
Two-port RAM
"""
word_size = 128 # Bits
num_words = 512
human_byte_size = "{:.0f}kbytes".format((word_size * num_words)/1024/8)
write_size = word_size # Bits

# Single port
num_rw_ports = 0
num_r_ports = 1
num_w_ports = 1
num_spare_rows= 0 # required only in 1rw case
num_spare_cols= 0 # requires only for 1rw case
ports_human = '1r1w'

tech_name = "sky130"
nominal_corner_only = True

route_supplies = "ring"
uniquify = True

output_name = f"sky130_sram_{ports_human}_{word_size}x{num_words}_{write_size}"
output_path = "./OpenRAM/8kB_mem"
