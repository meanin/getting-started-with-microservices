FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
COPY ["ScaffoldedWebApi/ScaffoldedWebApi.csproj", "ScaffoldedWebApi/"]
RUN dotnet restore "ScaffoldedWebApi/ScaffoldedWebApi.csproj"
COPY . .
WORKDIR "/src/ScaffoldedWebApi"
RUN dotnet build "ScaffoldedWebApi.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "ScaffoldedWebApi.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "ScaffoldedWebApi.dll"]