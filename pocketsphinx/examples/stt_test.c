#include <pocketsphinx.h>
#include <stdlib.h>
#include <stdio.h>

int audio_to_text(const char *file_path, 
                    const char *hmm_path, 
                    const char *lm_path,
                    const char *dict_path)
{
    ps_decoder_t *decoder;
    ps_config_t *config;
    FILE *fh;
    short *buf;
    size_t len, nsamples;

    /* Open the audio file */
    if ((fh = fopen(file_path, "rb")) == NULL) {
        fprintf(stderr, "Failed to open %s\n", file_path);
        return -1;
    }

    /* Get the size of the input file */
    if (fseek(fh, 0, SEEK_END) < 0) {
        perror("Unable to find end of input file");
        fclose(fh);
        return -2;
    }
    len = ftell(fh);
    rewind(fh);

    /* Initialize configuration from input file */
    config = ps_config_init(NULL);
    ps_default_search_args(config);

    if((hmm_path != NULL) && (lm_path != NULL) && (dict_path != NULL)) {
        ps_config_set_str(config, "-hmm", hmm_path);
        ps_config_set_str(config, "-lm", lm_path);
        ps_config_set_str(config, "-dict", dict_path);
    }

    if (ps_config_soundfile(config, fh, file_path) < 0) {
        fprintf(stderr, "Unsupported input file %s\n", file_path);
        fclose(fh);
        ps_config_free(config);
        return -3;
    }
    if ((decoder = ps_init(config)) == NULL) {
        fprintf(stderr, "PocketSphinx decoder init failed\n");
        fclose(fh);
        ps_config_free(config);
        return -4;
    }

    /* Allocate data (skipping header) */
    len -= ftell(fh);
    if ((buf = malloc(len)) == NULL) {
        perror("Unable to allocate memory for audio data");
        fclose(fh);
        ps_free(decoder);
        ps_config_free(config);
        return -5;
    }

    /* Read input */
    nsamples = fread(buf, sizeof(buf[0]), len / sizeof(buf[0]), fh);
    if (nsamples != len / sizeof(buf[0])) {
        perror("Unable to read samples");
        fclose(fh);
        free(buf);
        ps_free(decoder);
        ps_config_free(config);
        return -6;
    }

    /* Recognize the audio */
    if (ps_start_utt(decoder) < 0) {
        fprintf(stderr, "Failed to start processing\n");
        fclose(fh);
        free(buf);
        ps_free(decoder);
        ps_config_free(config);
        return -7;
    }
    if (ps_process_raw(decoder, buf, nsamples, FALSE, TRUE) < 0) {
        fprintf(stderr, "ps_process_raw() failed\n");
        fclose(fh);
        free(buf);
        ps_free(decoder);
        ps_config_free(config);
        return -8;
    }
    if (ps_end_utt(decoder) < 0) {
        fprintf(stderr, "Failed to end processing\n");
        fclose(fh);
        free(buf);
        ps_free(decoder);
        ps_config_free(config);
        return -9;
    }

    /* Print the recognition result */
    const char *hyp = ps_get_hyp(decoder, NULL);
    if (hyp != NULL)
        printf("Recognized text: %s\n", hyp);
    else
        fprintf(stderr, "No recognition result available\n");

    /* Clean up */
    fclose(fh);
    free(buf);
    ps_free(decoder);
    ps_config_free(config);

    return 0; /* Success */
}


int main() {
    const char *file_path = "./002.wav";
    const char *hmm_path = "./model/en-us/en-us";
    const char *lm_path = "./model/en-us/en-us.lm.bin";
    const char *dict_path = "./model/en-us/cmudict-en-us.dict";
    int result = audio_to_text(file_path, hmm_path, lm_path, dict_path);
    if (result != 0) {
        fprintf(stderr, "Error: audio_to_text failed with code %d\n", result);
    }
    return result;
}
