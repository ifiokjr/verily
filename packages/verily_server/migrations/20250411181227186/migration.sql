BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "action" ADD COLUMN "locationId" bigint;
ALTER TABLE "action" ADD COLUMN "validFrom" timestamp without time zone;
ALTER TABLE "action" ADD COLUMN "validUntil" timestamp without time zone;
ALTER TABLE "action" ADD COLUMN "maxCompletionTimeSeconds" bigint;
ALTER TABLE "action" ADD COLUMN "strictOrder" boolean NOT NULL DEFAULT true;
CREATE INDEX "action_locationId_idx" ON "action" USING btree ("locationId");
CREATE INDEX "action_valid_times_idx" ON "action" USING btree ("validFrom", "validUntil");
--
-- ACTION CREATE TABLE
--
CREATE TABLE "location" (
    "id" bigserial PRIMARY KEY,
    "latitude" double precision NOT NULL,
    "longitude" double precision NOT NULL,
    "radiusMeters" double precision,
    "googlePlacesId" text,
    "address" text,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "location_lat_lon_idx" ON "location" USING btree ("latitude", "longitude");
CREATE INDEX "location_google_places_id_idx" ON "location" USING btree ("googlePlacesId");


--
-- MIGRATION VERSION FOR verily
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('verily', '20250411181227186', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250411181227186', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20240520102713718', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240520102713718', "timestamp" = now();


COMMIT;
