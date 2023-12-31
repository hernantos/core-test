#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 5001

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["OpenshiftNotificationTest.csproj", "."]
RUN dotnet restore "./OpenshiftNotificationTest.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "OpenshiftNotificationTest.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "OpenshiftNotificationTest.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENV ASPNETCORE_URLS=http://+:5001
ENTRYPOINT ["dotnet", "OpenshiftNotificationTest.dll"]