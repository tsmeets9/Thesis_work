class Driver #(config_t cfg);

  virtual intf #(cfg) intf_i;

  mailbox #(Transaction_Feature #(cfg)) gen2drv_feature;
  mailbox #(Transaction_Masks #(cfg)) gen2drv_masks;
  mailbox #(Transaction_Kernel #(cfg)) gen2drv_kernel;

  function new(
    virtual intf #(cfg) i,
    mailbox #(Transaction_Feature #(cfg)) g2d_feature,
    mailbox #(Transaction_Masks #(cfg)) g2d_masks,
    mailbox #(Transaction_Kernel #(cfg)) g2d_kernel
  );
    intf_i = i;
    gen2drv_feature = g2d_feature;
    gen2drv_masks = g2d_masks;
    gen2drv_kernel = g2d_kernel;
  endfunction : new

  task reset;
    $display("[DRV] ----- Reset Started -----");
     //asynchronous start of reset
    intf_i.cb.start   <= 0;
    intf_i.cb.activations_valid <= 0;
    intf_i.cb.masks_valid <= 0;
    intf_i.cb.weights_valid <= 0;
    intf_i.cb.arst_n  <= 0;
    repeat (2) @(intf_i.cb);
    intf_i.cb.arst_n  <= 1; //synchronous release of reset
    repeat (2) @(intf_i.cb);
    $display("[DRV] -----  Reset Ended  -----");
  endtask

  task run();
    bit first = 1;

    // Get a transaction with kernel from the Generator
    // Kernel remains same throughput the verification

    Transaction_Masks #(cfg) tract_masks;
    Transaction_Feature #(cfg) tract_feature;

    Transaction_Kernel #(cfg) tract_kernel;
    gen2drv_kernel.get(tract_kernel);

    $display("[DRV] -----  Start execution -----");
    forever begin
      time starttime;
      // Get transactions with features and masks from the Generator
      gen2drv_masks.get(tract_masks);
      gen2drv_feature.get(tract_feature);
      
      $display("[DRV] Giving start signal");
      intf_i.cb.start <= 1;
      starttime = $time();
      @(intf_i.cb);
      intf_i.cb.start <= 0;

      $display("[DRV] ----- Driving the kernel memory");
      for(int outch=0;outch<cfg.OUTPUT_NB_CHANNELS/16; outch++) begin
        $display("[DRV] %.2f %% of the kernels is transferred", ((outch)*100.0*16)/cfg.OUTPUT_NB_CHANNELS);
        for(int inch=0;inch<cfg.INPUT_NB_CHANNELS; inch++) begin
          for(int ky=0;ky<cfg.KERNEL_SIZE; ky++) begin
            for(int kx=0;kx<cfg.KERNEL_SIZE; kx++) begin
                
                intf_i.cb.weights_valid <= 1;

                assert (!$isunknown(tract_kernel.kernel[ky][kx][inch][16*outch+0]));
                intf_i.cb.weights_input[cfg.MEM_BW - 1 - 8*0: cfg.MEM_BW - 8 - 8*0] <= tract_kernel.kernel[ky][kx][inch][16*outch+0];
                
                assert (!$isunknown(tract_kernel.kernel[ky][kx][inch][16*outch+1]));
                intf_i.cb.weights_input[cfg.MEM_BW - 1 - 8*1: cfg.MEM_BW - 8 - 8*1] <= tract_kernel.kernel[ky][kx][inch][16*outch+1];

                assert (!$isunknown(tract_kernel.kernel[ky][kx][inch][16*outch+2]));
                intf_i.cb.weights_input[cfg.MEM_BW - 1 - 8*2: cfg.MEM_BW - 8 - 8*2] <= tract_kernel.kernel[ky][kx][inch][16*outch+2];

                assert (!$isunknown(tract_kernel.kernel[ky][kx][inch][16*outch+3]));
                intf_i.cb.weights_input[cfg.MEM_BW - 1 - 8*3: cfg.MEM_BW - 8 - 8*3] <= tract_kernel.kernel[ky][kx][inch][16*outch+3];

                assert (!$isunknown(tract_kernel.kernel[ky][kx][inch][16*outch+4]));
                intf_i.cb.weights_input[cfg.MEM_BW - 1 - 8*4: cfg.MEM_BW - 8 - 8*4] <= tract_kernel.kernel[ky][kx][inch][16*outch+4];

                assert (!$isunknown(tract_kernel.kernel[ky][kx][inch][16*outch+5]));
                intf_i.cb.weights_input[cfg.MEM_BW - 1 - 8*5: cfg.MEM_BW - 8 - 8*5] <= tract_kernel.kernel[ky][kx][inch][16*outch+5];

                assert (!$isunknown(tract_kernel.kernel[ky][kx][inch][16*outch+6]));
                intf_i.cb.weights_input[cfg.MEM_BW - 1 - 8*6: cfg.MEM_BW - 8 - 8*6] <= tract_kernel.kernel[ky][kx][inch][16*outch+6];

                assert (!$isunknown(tract_kernel.kernel[ky][kx][inch][16*outch+7]));
                intf_i.cb.weights_input[cfg.MEM_BW - 1 - 8*7: cfg.MEM_BW - 8 - 8*7] <= tract_kernel.kernel[ky][kx][inch][16*outch+7];

                assert (!$isunknown(tract_kernel.kernel[ky][kx][inch][16*outch+8]));
                intf_i.cb.weights_input[cfg.MEM_BW - 1 - 8*8: cfg.MEM_BW - 8 - 8*8] <= tract_kernel.kernel[ky][kx][inch][16*outch+8];

                assert (!$isunknown(tract_kernel.kernel[ky][kx][inch][16*outch+9]));
                intf_i.cb.weights_input[cfg.MEM_BW - 1 - 8*9: cfg.MEM_BW - 8 - 8*9] <= tract_kernel.kernel[ky][kx][inch][16*outch+9];

                assert (!$isunknown(tract_kernel.kernel[ky][kx][inch][16*outch+10]));
                intf_i.cb.weights_input[cfg.MEM_BW - 1 - 8*10: cfg.MEM_BW - 8 - 8*10] <= tract_kernel.kernel[ky][kx][inch][16*outch+10];

                assert (!$isunknown(tract_kernel.kernel[ky][kx][inch][16*outch+11]));
                intf_i.cb.weights_input[cfg.MEM_BW - 1 - 8*11: cfg.MEM_BW - 8 - 8*11] <= tract_kernel.kernel[ky][kx][inch][16*outch+11];

                assert (!$isunknown(tract_kernel.kernel[ky][kx][inch][16*outch+12]));
                intf_i.cb.weights_input[cfg.MEM_BW - 1 - 8*12: cfg.MEM_BW - 8 - 8*12] <= tract_kernel.kernel[ky][kx][inch][16*outch+12];

                assert (!$isunknown(tract_kernel.kernel[ky][kx][inch][16*outch+13]));
                intf_i.cb.weights_input[cfg.MEM_BW - 1 - 8*13: cfg.MEM_BW - 8 - 8*13] <= tract_kernel.kernel[ky][kx][inch][16*outch+13];

                assert (!$isunknown(tract_kernel.kernel[ky][kx][inch][16*outch+14]));
                intf_i.cb.weights_input[cfg.MEM_BW - 1 - 8*14: cfg.MEM_BW - 8 - 8*14] <= tract_kernel.kernel[ky][kx][inch][16*outch+14];

                assert (!$isunknown(tract_kernel.kernel[ky][kx][inch][16*outch+15]));
                intf_i.cb.weights_input[cfg.MEM_BW - 1 - 8*15: cfg.MEM_BW - 8 - 8*15] <= tract_kernel.kernel[ky][kx][inch][16*outch+15];

                 
                //end

                @(intf_i.cb iff intf_i.cb.weights_ready);
                intf_i.cb.weights_valid <= 0;

            end
          end
        end
      end

      fork 
        begin
          // Drive masks
          $display("[DRV] ----- Driving a new input feature map masks -----");
          for(int i=0;i<((cfg.FEATURE_MAP_WIDTH-1)/16+1)*cfg.FEATURE_MAP_HEIGHT*cfg.INPUT_NB_CHANNELS/8; i++) begin
            $display("[DRV] %.2f %% of the input feature map masks is transferred", ((i)*100.0)/(((cfg.FEATURE_MAP_WIDTH-1)/16+1)*cfg.FEATURE_MAP_HEIGHT*cfg.INPUT_NB_CHANNELS/8));               
            intf_i.cb.masks_valid <= 1;

              assert (!$isunknown(tract_masks.masks[i]));
              intf_i.cb.masks_input <= tract_masks.masks[i];

            @(intf_i.cb iff intf_i.cb.masks_ready);
            intf_i.cb.masks_valid <= 0; 
          end
        end
        begin 
          // Drive activations
          for(int i=0;i<((cfg.FEATURE_MAP_WIDTH-1)/16+1)*cfg.FEATURE_MAP_HEIGHT*cfg.INPUT_NB_CHANNELS; i++) begin
            intf_i.cb.activations_valid <= 1;

              assert (!$isunknown(tract_feature.inputs[i]));
              intf_i.cb.activations_input <= tract_feature.inputs[i];

            @(intf_i.cb iff intf_i.cb.activations_ready);
            intf_i.cb.activations_valid <= 0; 
          end
        end
      join
    end
  endtask : run
endclass : Driver
