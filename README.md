# Fn Docker Init Image for creating Kotlin functions

For more details on *init-image*, see [here](https://medium.com/fnproject/even-wider-language-support-in-fn-with-init-images-a7a1b3135a6e) and [here](https://github.com/fnproject/docs/blob/master/cli/how-to/create-init-image.md).


`tar -cf kotlin-init.tar Dockerfile func.init.yaml pom.xml src/`


`docker build -t kotlin-init -f Dockerfile-init .`

 
`fn init --init-image=kotlin-init`
