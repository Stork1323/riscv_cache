import cache_def::*;

module d_victim_cache(
    input logic clk_i,
    input logic rst_ni,
    input evict_data_type evict_data_i,
    input cpu_req_type cpu_req_i,
    output evict_data_type victim_result_o,
    output logic [31:0] no_acc_o,
    output logic [31:0] no_hit_o,
    output logic [31:0] no_miss_o,
    output logic vc_miss_o
);

    /* signal enable lru load */
    logic lru_valid;

    /* address of ways from cache array to pLRU */
    logic [INDEX_WAY_VC-1:0] address_way_a2p;

    /* address of ways from pLRU to cache array */
    logic [INDEX_WAY_VC-1:0] address_way_p2a;

    /* interface signals to cache tag memory */
    vc_cache_tag_type tag_read; // tag read result
    vc_cache_tag_type tag_write; // tag write data
    vc_cache_req_type tag_req; // tag request

    /* interface signals to cache data memory */
    cache_data_type data_read; // cache line read data
    cache_data_type data_write; // cache line write data
    vc_cache_req_type data_req; // data request

    logic full_w; // signal notices that set is full or not


    /* choose address */
    d_victim_cache_LRU DVC_LRU(
        .clk_i(clk_i),
        .rst_ni(rst_ni),
        .valid_i(lru_valid),
        //.index_i(),
        .address_i(address_way_a2p),
        .address_o(address_way_p2a)
    );
    /* connect cache tag/data memory */
    d_victim_cache_tag DVC_CTAG(
        .clk_i(clk_i),
        .tag_req_i(tag_req),
        .tag_write_i(tag_write),
        .address_way_i(address_way_p2a),
        .cpu_address_i(cpu_req_i.addr),
        .address_way_o(address_way_a2p),
        .tag_read_o(tag_read),
        .full_o(full_w)
    );
    d_victim_cache_data DVC_CDATA(
        .clk_i(clk_i),
        .data_req_i(data_req), 
        .data_write_i(data_write),
        .address_way_tag2data_i(address_way_a2p),
        .data_read_o(data_read)
    );
    /* FSM cache controller */
    d_victim_cache_controller DVC_CTRL(
        .clk_i(clk_i),
        .rst_ni(rst_ni),
        .cpu_req_i(cpu_req_i),
        //.l1_cache_request_i(l1_cache_request_i),
        .evict_data_i(evict_data_i),
        .tag_read_i(tag_read),
        .data_read_i(data_read),
        .full_i(full_w),
        .tag_write_o(tag_write),
        .tag_req_o(tag_req),
        .data_write_o(data_write),
        .data_req_o(data_req),
        //.cpu_res_o(cpu_res_o),
        //.mem_req_o(),
        .victim_result_o(victim_result_o),
        .no_acc_o(no_acc_o),
        .no_hit_o(no_hit_o),
        .no_miss_o(no_miss_o),
        .lru_valid_o(lru_valid),
        .accessing_o(),
        .vc_miss_o(vc_miss_o)
    );

endmodule
