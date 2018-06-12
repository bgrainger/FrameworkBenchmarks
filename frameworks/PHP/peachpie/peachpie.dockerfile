FROM microsoft/dotnet:2.1-sdk-stretch AS build
WORKDIR /app
COPY . .
RUN dotnet build -c Release peachpie/Peachpie.sln
RUN dotnet publish -c Release -o ../out Server
RUN dotnet build -c Release -f netstandard2.0 peachpie/ext/MySqlConnector/src/MySqlConnector/MySqlConnector.csproj
RUN cp peachpie/ext/MySqlConnector/src/MySqlConnector/bin/Release/netstandard2.0/MySqlConnector.dll out/

FROM microsoft/dotnet:2.1-aspnetcore-runtime AS runtime
ENV COMPlus_ReadyToRun 0
WORKDIR /app
COPY --from=build /app/out ./

ENTRYPOINT ["dotnet", "Server.dll"]
