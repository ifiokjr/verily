BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "action" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "description" text NOT NULL,
    "creatorId" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "action_creatorId_idx" ON "action" USING btree ("creatorId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "action_step" (
    "id" bigserial PRIMARY KEY,
    "actionId" bigint NOT NULL,
    "stepType" text NOT NULL,
    "parameters" text NOT NULL,
    "order" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "_actionStepsActionId" bigint
);

-- Indexes
CREATE INDEX "action_step_actionId_idx" ON "action_step" USING btree ("actionId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "verification_attempt" (
    "id" bigserial PRIMARY KEY,
    "actionId" bigint NOT NULL,
    "userId" text NOT NULL,
    "status" text NOT NULL,
    "startedAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL,
    "completedAt" timestamp without time zone,
    "progressData" text
);

-- Indexes
CREATE INDEX "verification_attempt_actionId_idx" ON "verification_attempt" USING btree ("actionId");
CREATE INDEX "verification_attempt_userId_idx" ON "verification_attempt" USING btree ("userId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "webhook" (
    "id" bigserial PRIMARY KEY,
    "actionId" bigint NOT NULL,
    "url" text NOT NULL,
    "secret" text NOT NULL,
    "triggerEvents" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "_actionWebhooksActionId" bigint
);

-- Indexes
CREATE INDEX "webhook_actionId_idx" ON "webhook" USING btree ("actionId");

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
ALTER TABLE ONLY "verification_attempt"
    ADD CONSTRAINT "verification_attempt_fk_0"
    FOREIGN KEY("actionId")
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
    VALUES ('verily', '20250410143735498', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250410143735498', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
