FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build

#Defining the work directory
WORKDIR /src

#Copying the file
COPY ["SampleApi.csproj", "./"]

#Running the File
RUN dotnet restore "SampleApi.csproj"

COPY . .

WORKDIR "/src/"

RUN dotnet build "SampleApi.csproj" -c Release -o /app/build

#Publishing the dotnet code

FROM build AS publish

RUN dotnet publish "SampleApi.csproj" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS final

WORKDIR /app

COPY --from=publish /app/publish .

ENTRYPOINT ["dotnet", "SampleApi.dll"]
