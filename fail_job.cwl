#!/usr/bin/env cwl-runner

cwlVersion: v1.1
class: CommandLineTool
$namespaces:
  cwltool: http://commonwl.org/cwltool#
baseCommand: [sh]
arguments:
- -c
- cat .netrc && 
  echo "/opt/conda/bin/papermill $(inputs.input_nb) $(inputs.output_nb) 
  -p min_lat '$(inputs.min_lat)'
  -p max_lat '$(inputs.max_lat)'
  -p min_lon '$(inputs.min_lon)'
  -p max_lon '$(inputs.max_lon)'
  -p master_date '$(inputs.master_date)'
  -p start_date '$(inputs.start_date)'
  -p end_date '$(inputs.end_date)'
  -p track_number '$(inputs.track_number)'" &&
  cat /tmp/thisshouldcauseanonzeroexitcode
hints:
  "cwltool:Secrets":
    secrets:
      - urs_user
      - urs_pass
requirements:
  DockerRequirement:
    dockerPull: hysds1/topsstack_hamsar:20220121
  InitialWorkDirRequirement:
    listing:
      - entryname: .netrc
        entry: |
          machine urs.earthdata.nasa.gov login $(inputs.urs_user) password $(inputs.urs_pass)
          macdef init
  NetworkAccess:
    class: NetworkAccess
    networkAccess: true
  ResourceRequirement:
    class: ResourceRequirement
    coresMin: 1
    # the next 3 are in mebibytes
    ramMin: 1024
    tmpdirMin: 1000
    outdirMin: 1000
inputs:
  urs_user: string
  urs_pass: string
  input_nb: string
  output_nb: string
  min_lat: float
  max_lat: float
  min_lon: float
  max_lon: float
  master_date: string
  start_date: string
  end_date: string
  track_number: int
outputs:
  stdout_file:
    type: stdout
  stderr_file:
    type: stderr
stdout: stdout_run_topsstack.txt
stderr: stderr_run_topsstack.txt
