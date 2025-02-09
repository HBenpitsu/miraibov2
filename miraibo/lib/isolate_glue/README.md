In this layer, usecases are dispached into separate isolate.

If there is no need to exploit the process into different isolate, just wrap the usecase, without using compute.
It is not allowed for skeleton to access usecase directly.
