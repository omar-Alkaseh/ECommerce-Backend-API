# Stage 1 Build

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /source

COPY ECommerce.Api/*.csproj ./ECommerce.Api/
COPY Application/*.csproj ./Application/
COPY Domain/*.csproj ./Domain/
COPY Contracts/*.csproj ./Contracts/
COPY Infrastructure/*.csproj ./Infrastructure/

RUN dotnet restore ECommerce.Api/ECommerce.Api.csproj

COPY ECommerce.Api/. ./ECommerce.Api
COPY Application/. ./Application
COPY Domain/. ./Domain
COPY Contracts/. ./Contracts
COPY Infrastructure/. ./Infrastructure

WORKDIR /source/ECommerce.Api
RUN dotnet publish -c Release -o /app --no-restore


# Final Stage (Final image)

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app ./
ENTRYPOINT [ "dotnet", "ECommerce.Api.dll" ]