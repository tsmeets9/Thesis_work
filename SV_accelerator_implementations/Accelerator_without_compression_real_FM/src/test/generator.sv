// parameterized class
class Generator #(config_t cfg);

  mailbox #(Transaction_Feature #(cfg)) gen2drv_feature, gen2chk_feature;
  mailbox #(Transaction_Kernel #(cfg)) gen2drv_kernel, gen2chk_kernel;
  int fd;
  // class constructor
  function new( 
    mailbox #(Transaction_Feature #(cfg)) g2d_feature, g2c_feature,
    mailbox #( Transaction_Kernel #(cfg)) g2d_kernel, g2c_kernel
  );
    gen2drv_feature = g2d_feature;
    gen2drv_kernel  = g2d_kernel;

    gen2chk_feature = g2c_feature;
    gen2chk_kernel  = g2c_kernel;
  endfunction : new

  task run();
    // load kernel from file and put in transactions
    Transaction_Kernel #(cfg) tract_kernel;
    tract_kernel = new();

    $display("[DRV] -----  Start execution -----");
    fd = $fopen ("weights.txt", "r");
    if (fd) $display("File was opened succesfully : %0d", fd);
    else $display("File was NOT opened succesfully : %0d", fd);
    

    for(int ky=0;ky<cfg.KERNEL_SIZE; ky++) begin
      for(int kx=0;kx<cfg.KERNEL_SIZE; kx++) begin
        for(int inch=0;inch<cfg.INPUT_NB_CHANNELS; inch++) begin
          for (int outch = 0; outch < cfg.OUTPUT_NB_CHANNELS; outch++) begin
              string line;
              logic [cfg.DATA_WIDTH-1:0] kernel_element; 
              $fgets(line, fd);
              kernel_element = line.atobin();
              tract_kernel.kernel[ky][kx][inch][outch] = kernel_element;
          end
        end
      end
    end

    $fclose(fd);
            
    gen2drv_kernel.put(tract_kernel);
    gen2chk_kernel.put(tract_kernel);
    forever
    begin
      // load features from file and put in transactions
      Transaction_Feature #(cfg) tract_feature;
      tract_feature = new();
      fd = $fopen ("activations.txt", "r");
      if (fd) $display("File was opened succesfully : %0d", fd);
      else $display("File was NOT opened succesfully : %0d", fd);
      for(int y=0;y<cfg.FEATURE_MAP_HEIGHT; y++) begin
        for(int x=0;x<cfg.FEATURE_MAP_WIDTH; x++) begin
          for(int inch=0;inch<cfg.INPUT_NB_CHANNELS; inch++) begin
            string line;
            logic [cfg.DATA_WIDTH-1:0] activations_element; 
            $fgets(line, fd);
            activations_element = line.atobin();
            tract_feature.inputs[y][x][inch] = activations_element;
          end
        end
      end
      $fclose(fd);
      gen2drv_feature.put(tract_feature);
      gen2chk_feature.put(tract_feature);

    end
  endtask : run

endclass : Generator
