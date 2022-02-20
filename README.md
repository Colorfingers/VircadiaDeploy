# VircadiaDeploy

## Packer
Using Packer we can easily stage Vircadia builds by running a simple script. According to the creator Hashicorp, "Packer is a tool for building identical machine images for multiple platforms from a single source configuration... Builders are responsible for creating machines and generating images from them for various platforms. For example, there are separate builders for EC2, VMware, VirtualBox, etc. Packer comes with many builders by default, and can also be extended to add new builders." 

Our first goal is to stage Vircadia domain servers using different builders. Once we have accomplished that goal we will move on to creating dev build boxes that will pull the requested Vircadia source code, build a machine suitable for compiling the code and compile the source to a binary. This can be useful for a number or reasons... for one, we can stage a Vircadia domain server after compiling the code so it can be tested, all through automation. The monkey just flips the switch.

Our third goal will be deployment orchestration using Hashicorp's Vagrant and Terraform tools to create load ballancing Vircadia domain servers and Kubernetes clusters... Most of this is trial and error so expect development of these technologies to move at a snails pace.

We will extend this readme as we move forward... for now, you will find instructions for using the different builds in each of the Packer build folders. If you need help, please feel free ask for help from others or myself @hapticmonkey in the Vircadia Discord https://discord.gg/5WVz5ubU or in the Vircadia forums https://forum.vircadia.com/.
