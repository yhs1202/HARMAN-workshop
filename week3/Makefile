# My VCS-Verdi Auto Build Makefile Script
# Author: Hoseung Yoon
# Last Modified: 2025.11.13

# Define directories
OUT := sim_out
RUN_SH := run.sh
RUN_VERDI_SH := run_verdi.sh
CLEAN_SH := clean.sh

# Default target: build -> sim -> Verdi RUN
all: run verdi

# Run VCS build + simulation
run:
	./$(RUN_SH)

# Open Verdi GUI
verdi:
	./$(RUN_VERDI_SH)

# Clean simulation outputs
clean:
	./$(CLEAN_SH)

# Rebuild completely
re: clean run