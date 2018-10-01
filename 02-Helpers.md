Microservices - small, independent processes communicating with each other using language-agnostic APIs. Fast deployable, easy to scale, independent data storage.

Hypervisor - is a tool for a hardware-virtualization process. The virtualization itself is a simulation of an phisical machine for a guest OS.
Hyper-V - Microsoft software of a hypervisor kind. On top of the hyper-v you can run guest virtual machine on a windows OS.

Docker - is a software that performs OS-virtualization (containerization). Used to run software packages called as containers.

Kubernetes - platform for managing containerized workloads and services. It orchestrates computing, networking, and storage infrastructure on behalf of user workloads.
POD - the smallest deployable object in the Kubernetes object model. It can either consist of one or more containers, but one is kind of a standard. Encapsulates container/s, network and storage.
Deployment - provides declarative updates for Pods based on the same image/s.
StatefulSet - used to manage stateful applications. Supports different states, reacting to the same input differently depending on the current state. Manages the deployment and scaling of a set of Pods and provides guarantees about the ordering and uniqueness of these Pods.
Services - an abstraction which defines a logical set of Pods and a policy by which to access them - sometimes called a microservice.