BEGIN;

--
-- ACTION DROP TABLE
--
DROP TABLE "action" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "action" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "description" text,
    "userInfoId" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL,
    "isDeleted" boolean NOT NULL DEFAULT false
);

-- Indexes
CREATE INDEX "action_userInfoId_idx" ON "action" USING btree ("userInfoId");
CREATE INDEX "action_created_at_idx" ON "action" USING btree ("createdAt");

--
-- ACTION DROP TABLE
--
DROP TABLE "action_step" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "action_step" (
    "id" bigserial PRIMARY KEY,
    "actionId" bigint NOT NULL,
    "type" text NOT NULL,
    "order" bigint NOT NULL,
    "parameters" text NOT NULL,
    "instruction" text,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL,
    "_actionStepsActionId" bigint
);

-- Indexes
CREATE INDEX "action_step_action_id_order_idx" ON "action_step" USING btree ("actionId", "order");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "creator" (
    "id" bigserial PRIMARY KEY,
    "userInfoId" bigint NOT NULL
);

--
-- ACTION ALTER TABLE
--
DROP INDEX "verification_attempt_actionId_idx";
DROP INDEX "verification_attempt_userId_idx";
ALTER TABLE "verification_attempt" DROP COLUMN "updatedAt";
ALTER TABLE "verification_attempt" DROP COLUMN "completedAt";
ALTER TABLE "verification_attempt" DROP COLUMN "progressData";
ALTER TABLE "verification_attempt" ADD COLUMN "lastUpdatedAt" timestamp without time zone;
ALTER TABLE "verification_attempt" ADD COLUMN "stepProgress" text;
ALTER TABLE "verification_attempt" ADD COLUMN "errorMessage" text;
CREATE INDEX "verification_attempt_action_id_user_id_idx" ON "verification_attempt" USING btree ("actionId", "userId");
CREATE INDEX "verification_attempt_status_idx" ON "verification_attempt" USING btree ("status");
CREATE INDEX "verification_attempt_started_at_idx" ON "verification_attempt" USING btree ("startedAt");
--
-- ACTION DROP TABLE
--
DROP TABLE "webhook" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "webhook" (
    "id" bigserial PRIMARY KEY,
    "actionId" bigint NOT NULL,
    "url" text NOT NULL,
    "secret" text,
    "subscribedEvents" text NOT NULL,
    "isActive" boolean NOT NULL DEFAULT true,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL,
    "_actionWebhooksActionId" bigint
);

-- Indexes
CREATE INDEX "webhook_action_id_idx" ON "webhook" USING btree ("actionId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "action_step"
    ADD CONSTRAINT "action_step_fk_0"
    FOREIGN KEY("actionId")
    REFERENCES "action"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "action_step"
    ADD CONSTRAINT "action_step_fk_1"
    FOREIGN KEY("_actionStepsActionId")
    REFERENCES "action"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "webhook"
    ADD CONSTRAINT "webhook_fk_0"
    FOREIGN KEY("actionId")
    REFERENCES "action"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "webhook"
    ADD CONSTRAINT "webhook_fk_1"
    FOREIGN KEY("_actionWebhooksActionId")
    REFERENCES "action"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR verily
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('verily', '20250411161105538', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250411161105538', "timestamp" = now();

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
