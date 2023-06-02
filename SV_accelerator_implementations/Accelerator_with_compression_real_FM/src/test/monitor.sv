class Monitor #( config_t cfg);
  virtual intf #(cfg) intf_i;
  mailbox #(Transaction_Output_Encoded#(cfg)) mon2chk_encoded;
  mailbox #(Transaction_Output_Masks#(cfg)) mon2chk_masks;


  function new(
    virtual intf #(cfg) intf_i,
    mailbox #(Transaction_Output_Encoded#(cfg)) m2c_encoded,
    mailbox #(Transaction_Output_Masks#(cfg)) m2c_masks

  );
    this.intf_i = intf_i;
    mon2chk_encoded = m2c_encoded;
    mon2chk_masks = m2c_masks;
  endfunction : new

  task run;
    @(intf_i.cb iff intf_i.arst_n);
    forever
    begin
      fork
        begin 
          for(int i=0;i<((cfg.FEATURE_MAP_WIDTH-1)/16+1)*cfg.FEATURE_MAP_HEIGHT*cfg.OUTPUT_NB_CHANNELS/8; i++) begin
            Transaction_Output_Masks #(cfg) tract_output_masks;
            @(intf_i.cb iff intf_i.cb.output_valid_masks);
            tract_output_masks = new();
            tract_output_masks.output_data_masks = intf_i.cb.output_data_masks;
            tract_output_masks.index    = i;
            $display("Index: %d, Data: %b is received", (tract_output_masks.index), (tract_output_masks.output_data_masks));
            mon2chk_masks.put(tract_output_masks);
          end
        end
        begin 
          for(int i=0;i<((cfg.FEATURE_MAP_WIDTH-1)/16+1)*cfg.FEATURE_MAP_HEIGHT*cfg.OUTPUT_NB_CHANNELS; i++) begin
            Transaction_Output_Encoded #(cfg) tract_output_encoded;
            @(intf_i.cb iff intf_i.cb.output_valid_encoded);
            tract_output_encoded = new();
            tract_output_encoded.output_data_encoded = intf_i.cb.output_data_encoded;
            tract_output_encoded.index    = i;
            $display("Index: %d, Data: %b is received", (tract_output_encoded.index), (tract_output_encoded.output_data_encoded));
            mon2chk_encoded.put(tract_output_encoded);
          end
        end
      join 
    end
  endtask

endclass : Monitor
