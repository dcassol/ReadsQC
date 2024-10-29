version 1.0
import "shortReadsqc.wdl" as srqc
import "longReadsqc.wdl" as lrqc

workflow rqcfilter{
    input {
    Array[String] input_files
    Array[String] input_fq1
    Array[String] input_fq2
    File?         reference
    String        proj
    Boolean       interleaved
    Boolean       shortRead
  }
    if (shortRead) {
        call srqc.ShortReadsQC{
            input:
            input_files = input_files,
            input_fq1 = input_fq1,
            input_fq2 = input_fq2,
            interleaved = interleaved,
            proj = proj
        }
    }
    if (!shortRead) {
        call lrqc.LongReadsQC{
            input:
            file = input_files[0],
            proj = proj,
            reference = reference,
        }
    }

    output {
        # short reads
        File? filtered_final_srqc = ShortReadsQC.filtered_final
        File? filtered_stats_final_srqc = ShortReadsQC.filtered_stats_final
        File? filtered_stats2_final_srqc = ShortReadsQC.filtered_stats2_final
        File? filtered_stats_json_srqc = ShortReadsQC.filter_stat_json
        File? rqc_info_srqc = ShortReadsQC.rqc_info
        File? stats = ShortReadsQC.filter_stat_json
        # long reads
        File? filtered_final_lrqc = LongReadsQC.filtered_final
        File? filtered_stats_final_lrqc = LongReadsQC.filtered_stats1
        File? filtered_stats2_final_lrqc = LongReadsQC.filtered_stats2
        File? filtered_stats3_final_lrqc = LongReadsQC.filtered_stats3
        File? rqc_info_lrqc = LongReadsQC.rqc_info

        # both
        #File? stats = if (shortRead) then ShortReadsQC.filter_stat_json else LongReadsQC.filter_stat_json
    }
}