package cache_def;
    // data structure for cache tag and data

    /* parameters for L1 cache */
    parameter int TAGMSB = 31; // tag msb
    parameter int TAGLSB = 6; // tag lsb : 4 bits offset (2 bit byte offset, 2 bit for 4 word), 2 bit index
    parameter int INDEX = 2; // Number of block bits
    parameter int DEPTH = 4; // Number of blocks
    parameter int WAYS = 8; // Number of ways
    /*-----------*/
    /* parameters for L2 cache */
    parameter int TAGMSB_L2 = 31; // tag msb
    parameter int TAGLSB_L2 = 8; // tag lsb : 4 bits offset (2 bit byte offset, 2 bit for 4 word), 4 bit index
    parameter int INDEX_L2 = 4; // number of block bits l2 cache
    parameter int DEPTH_L2 = 16; // number of blocks l2 cache
    parameter int WAYS_L2 = 8; // Number of ways
    /*----------*/
    /* parameters for victim cache */
    parameter int TAGMSB_VC = 31; // tag msb
    parameter int TAGLSB_VC = 4; // tag lsb : 4 bits offset (2 bit byte offset, 2 bit for 4 word), 0 bit index
    parameter int INDEX_VC = 1; // number of block bits victim cache
    parameter int DEPTH_VC = 1; // number of blocks victim cache
    parameter int WAYS_VC = 8; // Number of ways
    parameter int INDEX_WAY_VC = 3; // Number bit of way address
    /*----------*/
    
    parameter int DATA_WIDTH = 128; // Number bits of cache line data
    parameter int INDEX_WAY = 3; // Number bit of way address
    parameter int NO_TAG_TYPE = 2+(TAGMSB-TAGLSB+1); // number bits of cache tag type, include 1 valid bit, 1 dirty bit, tag bits

    // data structure for cache tag
    typedef struct packed {
        logic valid; // valid bit
        logic dirty; // dirty bit
        logic [TAGMSB:TAGLSB] tag; // tag bits
    } cache_tag_type;

    typedef struct packed {
        logic valid; // valid bit
        logic dirty; // dirty bit
        logic [TAGMSB_L2:TAGLSB_L2] tag; // tag bits
    } l2_cache_tag_type;

    typedef struct packed {
        logic valid; // valid bit
        logic dirty; // dirty bit
        logic [TAGMSB_VC:TAGLSB_VC] tag; // tag bits
    } vc_cache_tag_type;


    // data structure for cache memory request 
    typedef struct {
        logic [INDEX-1:0] index;
        logic we; // write enable
    } cache_req_type;

    typedef struct {
        logic [INDEX_L2-1:0] index;
        logic we; // write enable
    } l2_cache_req_type;

    typedef struct {
        // logic [INDEX_VC-1:0] index;
        logic we; // write enable
    } vc_cache_req_type;

    // 128-bit cache line data
    //typedef logic [127:0] cache_data_type;
    typedef logic [DATA_WIDTH-1:0] cache_data_type;

    //--------------------------
    // data structures for CPU <=> Cache constroller interface

    // CPU request (CPU -> cache controller)
    typedef struct {
        logic [31:0] addr; // 32-bit request addr
        logic [31:0] data; // 32-bit request data (used when write)
        logic rw; // request type : 0 = read, 1 = write
        logic valid;
    } cpu_req_type;

    // Cache result (cache controller -> CPU)
    typedef struct {
        logic [31:0] data; // 32-bit data
        logic ready; // result is ready
    } cpu_result_type;

    //-----------------------------------
    // data structures for cache controller <-> memory interface
    
    // memory request (cache controller -> memory)
    typedef struct {
        logic [31:0] addr; // request byte addr
        cache_data_type data; // 128-bit request data (used when write)
        logic rw; // request type : 0 = read, 1 = write
        logic valid; // request is valid
    } mem_req_type;

    // memory response (memory -> cache controller)
    typedef struct {
        cache_data_type data; // 128-bit read back data
        logic ready; // data is ready
    } mem_data_type;

    /* evict data type for transfering infos from l1 cache to victim cache */
    typedef struct {
        logic [31:0] addr;
        cache_data_type data;
        logic valid;
        logic dirty; // dirty bit from l1 cache
    } evict_data_type;

endpackage
