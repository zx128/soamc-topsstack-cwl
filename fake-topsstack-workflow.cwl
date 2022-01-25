#!/usr/bin/env cwl-runner

cwlVersion: v1.1
class: Workflow
$namespaces:
  cwltool: http://commonwl.org/cwltool#
hints:
  "cwltool:Secrets":
    secrets:
      - workflow_aws_access_key_id
      - workflow_aws_secret_access_key
inputs:
  workflow_urs_user: string
  workflow_urs_pass: string
  workflow_input_nb: string
  workflow_output_nb: string
  workflow_min_lat: float
  workflow_max_lat: float
  workflow_min_lon: float
  workflow_max_lon: float
  workflow_master_date: string
  workflow_start_date: string
  workflow_end_date: string
  workflow_track_number: int
  workflow_aws_access_key_id: string
  workflow_aws_secret_access_key: string
  workflow_base_dataset_url: string

outputs:
  final_dataset_dir:
    type: Directory
    outputSource: echo-papermill/dataset_dir
  stdout_echo-papermill:
    type: File
    outputSource: echo-papermill/stdout_file
  stderr_echo-papermill:
    type: File
    outputSource: echo-papermill/stderr_file
  stdout_stage-out:
    type: File
    outputSource: stage-out/stdout_file
  stderr_stage-out:
    type: File
    outputSource: stage-out/stderr_file

steps:
  echo-papermill:
    run: echo_papermill.cwl
    in:
      urs_user: workflow_urs_user
      urs_pass: workflow_urs_pass
      input_nb: workflow_input_nb
      output_nb: workflow_output_nb
      min_lat: workflow_min_lat
      max_lat: workflow_max_lat
      min_lon: workflow_min_lon
      max_lon: workflow_max_lon
      master_date: workflow_master_date
      start_date: workflow_start_date
      end_date: workflow_end_date
      track_number: workflow_track_number
    out:
    - dataset_dir
    - stdout_file
    - stderr_file

  stage-out:
    run: stage-out.cwl
    in:
      aws_access_key_id: workflow_aws_access_key_id
      aws_secret_access_key: workflow_aws_secret_access_key
      dataset_dir: echo-papermill/dataset_dir
      base_dataset_url: workflow_base_dataset_url
    out:
    - stdout_file
    - stderr_file
