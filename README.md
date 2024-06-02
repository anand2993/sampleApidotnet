# sampleApidotnet
Creating dotnet project for sample docker build
Create Dockerfile:
Create a Dockerfile in the root of your project directory (SampleApi) with the following content:

Dockerfile
Copy code
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["SampleApi.csproj", "./"]
RUN dotnet restore "SampleApi.csproj"
COPY . .
WORKDIR "/src/"
RUN dotnet build "SampleApi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "SampleApi.csproj" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "SampleApi.dll"]
4. Commit Your Changes:
Commit your changes to the Git repository:

bash
Copy code
git add .
git commit -m "Initial commit"
5. Create Azure DevOps Pipeline:
Go to your Azure DevOps project.
Navigate to Pipelines > Pipelines and click on New pipeline.
Select your Git repository as the source.
Choose Starter pipeline or Empty pipeline.
Replace the content of the generated YAML file with the following pipeline definition:
yaml
Copy code
trigger:
- main

pool:
  vmImage: 'ubuntu-latest'

steps:
- task: UseDotNet@2
  inputs:
    version: '5.x'
    includePreviewVersions: true

- task: Docker@2
  inputs:
    containerRegistry: 'yourDockerRegistryServiceConnection' # Provide your Docker registry service connection name
    repository: 'sample-api'
    command: 'build'
    Dockerfile: '**/Dockerfile'
    tags: 'latest'

- task: Docker@2
  inputs:
    containerRegistry: 'yourDockerRegistryServiceConnection' # Provide your Docker registry service connection name
    repository: 'sample-api'
    command: 'push'
    tags: 'latest'
Replace 'yourDockerRegistryServiceConnection' with the name of your Docker registry service connection in Azure DevOps.

6. Save and Run Pipeline:
Save the pipeline YAML file and run the pipeline. It will build the .NET project, create a Docker image, and push it to your Docker registry.
