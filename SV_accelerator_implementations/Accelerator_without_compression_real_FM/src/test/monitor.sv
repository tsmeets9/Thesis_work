class Monitor #( config_t cfg);
  virtual intf #(cfg) intf_i;
  mailbox #(Transaction_Output_Word#(cfg)) mon2chk;

  function new(
    virtual intf #(cfg) intf_i,
    mailbox #(Transaction_Output_Word#(cfg)) m2c
  );
    this.intf_i = intf_i;
    mon2chk = m2c;
  endfunction : new

  task run;
    @(intf_i.cb iff intf_i.arst_n);
    forever
    begin
      for(int y=0;y<cfg.FEATURE_MAP_HEIGHT; y++) begin
        for(int x=0;x<(cfg.FEATURE_MAP_WIDTH-1)/16+1; x++) begin
          for(int outch=0;outch<cfg.OUTPUT_NB_CHANNELS/16; outch++) begin
            for (int j = 0; j < 16; j = j + 1) begin
              Transaction_Output_Word #(cfg) tract_output;
              @(intf_i.cb iff intf_i.cb.output_valid);

              if (16*x+0 < cfg.FEATURE_MAP_WIDTH && 16*outch+j < cfg.OUTPUT_NB_CHANNELS) begin 
                tract_output = new();
                tract_output.output_data = intf_i.cb.output_data[cfg.MEM_BW - 1 - 8*0: cfg.MEM_BW - 8 - 8*0];
                tract_output.output_x    = 16*x+0;
                tract_output.output_y    = y;
                tract_output.output_ch   = 16*outch+j;
                mon2chk.put(tract_output);
              end

              if (16*x+1 < cfg.FEATURE_MAP_WIDTH && 16*outch+j < cfg.OUTPUT_NB_CHANNELS) begin 
                tract_output = new();
                tract_output.output_data = intf_i.cb.output_data[cfg.MEM_BW - 1 - 8*1: cfg.MEM_BW - 8 - 8*1];
                tract_output.output_x    = 16*x+1;
                tract_output.output_y    = y;
                tract_output.output_ch   = 16*outch+j;
                mon2chk.put(tract_output);
              end

              if (16*x+2 < cfg.FEATURE_MAP_WIDTH && 16*outch+j < cfg.OUTPUT_NB_CHANNELS) begin 
                tract_output = new();
                tract_output.output_data = intf_i.cb.output_data[cfg.MEM_BW - 1 - 8*2: cfg.MEM_BW - 8 - 8*2];
                tract_output.output_x    = 16*x+2;
                tract_output.output_y    = y;
                tract_output.output_ch   = 16*outch+j;
                mon2chk.put(tract_output);
              end

              if (16*x+3 < cfg.FEATURE_MAP_WIDTH && 16*outch+j < cfg.OUTPUT_NB_CHANNELS) begin 
                tract_output = new();
                tract_output.output_data = intf_i.cb.output_data[cfg.MEM_BW - 1 - 8*3: cfg.MEM_BW - 8 - 8*3];
                tract_output.output_x    = 16*x+3;
                tract_output.output_y    = y;
                tract_output.output_ch   = 16*outch+j;
                mon2chk.put(tract_output);
              end

              if (16*x+4 < cfg.FEATURE_MAP_WIDTH && 16*outch+j < cfg.OUTPUT_NB_CHANNELS) begin 
                tract_output = new();
                tract_output.output_data = intf_i.cb.output_data[cfg.MEM_BW - 1 - 8*4: cfg.MEM_BW - 8 - 8*4];
                tract_output.output_x    = 16*x+4;
                tract_output.output_y    = y;
                tract_output.output_ch   = 16*outch+j;
                mon2chk.put(tract_output);
              end

              if (16*x+5 < cfg.FEATURE_MAP_WIDTH && 16*outch+j < cfg.OUTPUT_NB_CHANNELS) begin 
                tract_output = new();
                tract_output.output_data = intf_i.cb.output_data[cfg.MEM_BW - 1 - 8*5: cfg.MEM_BW - 8 - 8*5];
                tract_output.output_x    = 16*x+5;
                tract_output.output_y    = y;
                tract_output.output_ch   = 16*outch+j;
                mon2chk.put(tract_output);
              end

              if (16*x+6 < cfg.FEATURE_MAP_WIDTH && 16*outch+j < cfg.OUTPUT_NB_CHANNELS) begin 
                tract_output = new();
                tract_output.output_data = intf_i.cb.output_data[cfg.MEM_BW - 1 - 8*6: cfg.MEM_BW - 8 - 8*6];
                tract_output.output_x    = 16*x+6;
                tract_output.output_y    = y;
                tract_output.output_ch   = 16*outch+j;
                mon2chk.put(tract_output);
              end

              if (16*x+7 < cfg.FEATURE_MAP_WIDTH && 16*outch+j < cfg.OUTPUT_NB_CHANNELS) begin 
                tract_output = new();
                tract_output.output_data = intf_i.cb.output_data[cfg.MEM_BW - 1 - 8*7: cfg.MEM_BW - 8 - 8*7];
                tract_output.output_x    = 16*x+7;
                tract_output.output_y    = y;
                tract_output.output_ch   = 16*outch+j;
                mon2chk.put(tract_output);
              end

              if (16*x+8 < cfg.FEATURE_MAP_WIDTH && 16*outch+j < cfg.OUTPUT_NB_CHANNELS) begin 
                tract_output = new();
                tract_output.output_data = intf_i.cb.output_data[cfg.MEM_BW - 1 - 8*8: cfg.MEM_BW - 8 - 8*8];
                tract_output.output_x    = 16*x+8;
                tract_output.output_y    = y;
                tract_output.output_ch   = 16*outch+j;
                mon2chk.put(tract_output);
              end

              if (16*x+9 < cfg.FEATURE_MAP_WIDTH && 16*outch+j < cfg.OUTPUT_NB_CHANNELS) begin 
                tract_output = new();
                tract_output.output_data = intf_i.cb.output_data[cfg.MEM_BW - 1 - 8*9: cfg.MEM_BW - 8 - 8*9];
                tract_output.output_x    = 16*x+9;
                tract_output.output_y    = y;
                tract_output.output_ch   = 16*outch+j;
                mon2chk.put(tract_output);
              end

              if (16*x+10 < cfg.FEATURE_MAP_WIDTH && 16*outch+j < cfg.OUTPUT_NB_CHANNELS) begin 
                tract_output = new();
                tract_output.output_data = intf_i.cb.output_data[cfg.MEM_BW - 1 - 8*10: cfg.MEM_BW - 8 - 8*10];
                tract_output.output_x    = 16*x+10;
                tract_output.output_y    = y;
                tract_output.output_ch   = 16*outch+j;
                mon2chk.put(tract_output);
              end

              if (16*x+11 < cfg.FEATURE_MAP_WIDTH && 16*outch+j < cfg.OUTPUT_NB_CHANNELS) begin 
                tract_output = new();
                tract_output.output_data = intf_i.cb.output_data[cfg.MEM_BW - 1 - 8*11: cfg.MEM_BW - 8 - 8*11];
                tract_output.output_x    = 16*x+11;
                tract_output.output_y    = y;
                tract_output.output_ch   = 16*outch+j;
                mon2chk.put(tract_output);
              end

              if (16*x+12 < cfg.FEATURE_MAP_WIDTH && 16*outch+j < cfg.OUTPUT_NB_CHANNELS) begin 
                tract_output = new();
                tract_output.output_data = intf_i.cb.output_data[cfg.MEM_BW - 1 - 8*12: cfg.MEM_BW - 8 - 8*12];
                tract_output.output_x    = 16*x+12;
                tract_output.output_y    = y;
                tract_output.output_ch   = 16*outch+j;
                mon2chk.put(tract_output);
              end

              if (16*x+13 < cfg.FEATURE_MAP_WIDTH && 16*outch+j < cfg.OUTPUT_NB_CHANNELS) begin 
                tract_output = new();
                tract_output.output_data = intf_i.cb.output_data[cfg.MEM_BW - 1 - 8*13: cfg.MEM_BW - 8 - 8*13];
                tract_output.output_x    = 16*x+13;
                tract_output.output_y    = y;
                tract_output.output_ch   = 16*outch+j;
                mon2chk.put(tract_output);
              end

              if (16*x+14 < cfg.FEATURE_MAP_WIDTH && 16*outch+j < cfg.OUTPUT_NB_CHANNELS) begin 
                tract_output = new();
                tract_output.output_data = intf_i.cb.output_data[cfg.MEM_BW - 1 - 8*14: cfg.MEM_BW - 8 - 8*14];
                tract_output.output_x    = 16*x+14;
                tract_output.output_y    = y;
                tract_output.output_ch   = 16*outch+j;
                mon2chk.put(tract_output);
              end

              if (16*x+15 < cfg.FEATURE_MAP_WIDTH && 16*outch+j < cfg.OUTPUT_NB_CHANNELS) begin 
                tract_output = new();
                tract_output.output_data = intf_i.cb.output_data[cfg.MEM_BW - 1 - 8*15: cfg.MEM_BW - 8 - 8*15];
                tract_output.output_x    = 16*x+15;
                tract_output.output_y    = y;
                tract_output.output_ch   = 16*outch+j;
                mon2chk.put(tract_output);
              end

            end
          end
        end
      end
    end
  endtask

endclass : Monitor
