#!/bin/bash
# run_evaluation.sh
# A reusable base script to run seahelm evaluations.

set -euo pipefail

# --- Main Function ---
main() {
    # Set variables with defaults that can be overridden by command-line arguments.
    local model_name="${1:-meta-llama/Meta-Llama-3.1-8B-Instruct}"
    local output_base_dir="${2:-results}"
    local model_type="${3:-vllm}"
    
    # --- Configuration Variables (Hardcoded) ---
    # If needed, take in input argument with the syntax 
    # "${variable:-default_value}"
    local python_script="seahelm_evaluation.py"
    local tasks="seahelm"
    local is_base_model=false
    local rerun_cached_results=false

    # --- Prepare Command-Line Arguments ---
    # Conditionally set arguments based on the boolean flags.
    local base_model_arg=""
    if [ "$is_base_model" = true ]; then
        base_model_arg="--base_model"
    fi

    local rerun_results_arg=""
    if [ "$rerun_cached_results" = true ]; then
        rerun_results_arg="--rerun_cached_results"
    fi

    # --- Create Output Directory ---
    # The output directory name is derived from the model name.
    local output_dir="${output_base_dir}/$(basename "${model}")"
    mkdir -p "${output_dir}"
    echo "Output directory created: ${output_dir}"

    # --- Check for Dependencies ---
    if [ ! -f "$python_script" ]; then
        echo "Error: Python script '$python_script' not found!" >&2
        exit 1
    fi

    # --- Run the Evaluation ---
    # Set environment variables for the evaluation process.
    export LITELLM_LOG="ERROR"

    # Use an array to build the command for clarity and correct quoting.
    local seahelm_eval_args=(
        "python" "$python_script"
        "--tasks" "$tasks"
        "--output_dir" "$output_dir"
        "--model_name" "$model_name"
        "--model_type" "$model_type"
        "$base_model_arg"
        "$rerun_results_arg"
    )

    #if [ -n "$base_model_arg" ]; then
    #    seahelm_eval_args+=("$base_model_arg")
    #fi
    #if [ -n "$rerun_results_arg" ]; then
    #    seahelm_eval_args+=("$rerun_results_arg")
    #fi

    # Conditionally add --model_args for vllm
    # LiteLLM and OLLama don't need this argument
    if [[ "$model_type" == "vllm" ]]; then
        seahelm_eval_args+=("--model_args" "dtype=bfloat16,enable_prefix_caching=True,tensor_parallel_size=1")
    elif [[ "$model_type" == "litellm" ]]; then
        seahelm_eval_args+=("--model_args" "api_provider=ollama,base_url=http://localhost:11434")
    fi

    echo "Running evaluation command:"
    printf "%s " "${seahelm_eval_args[@]}"
    echo ""

    # Execute the final command.
    "${seahelm_eval_args[@]}"
}

# python seahelm_evaluation.py --tasks seahelm --output_dir $OUTPUT_DIR --model_type litellm --model_name $MODEL_NAME --model_args "api_provider=ollama,base_url=http://localhost:11434"

# Run the main function with all provided arguments.
main "$@"