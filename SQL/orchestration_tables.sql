-- ============================================================
-- Database: DB_Procurement (Fabric SQL Database)
-- Purpose: Orchestration tables supporting incremental loads
--          and pipeline execution auditing. Referenced and
--          updated by the stored procedures in
--          stored_procedures.sql.
-- ============================================================


-- ============================================================
-- Table: Watermark_Procurement
-- Purpose: Tracks the last successful load time per source
--          table, enabling incremental (delta) loads. Each
--          pipeline run pulls only records changed since the
--          stored watermark, rather than reprocessing the
--          full source table on every run.
-- Updated by: sp_LastModify, at the end of each successful
--             table load (sets Last_Modified_Date = GETDATE()
--             for the given Table_Name)
-- ============================================================
CREATE TABLE Watermark_Procurement
(
    Object_ID           INT           NOT NULL PRIMARY KEY,
    Table_Name           VARCHAR(100)  NOT NULL,
    Last_Modified_Date   DATETIME      NULL
);
GO


-- ============================================================
-- Table: Pipeline_Execution_History
-- Purpose: Full audit log of every pipeline run, per table,
--          per execution. Used to trace success/failure and
--          timing across runs.
-- Updated by: SP_Pipeline_History, called at the start and
--             end of each pipeline activity
-- ============================================================
CREATE TABLE Pipeline_Execution_History
(
    Pipeline_Name      VARCHAR(100)  NOT NULL,
    Table_Name          VARCHAR(100)  NOT NULL,
    Execution_Status    VARCHAR(20)   NOT NULL,
    Start_Time          DATETIME      NOT NULL,
    End_Time             DATETIME      NULL
);
GO


-- ============================================================
-- Table: Procurement_Tables
-- Purpose: Reference/metadata table listing each procurement
--          source table tracked by the pipeline. Used with
--          Watermark_Procurement to drive the ForEach loop's
--          dynamic table list during ingestion.
-- ============================================================
CREATE TABLE Procurement_Tables
(
    Table_Name  VARCHAR(100)  NOT NULL PRIMARY KEY
);
GO


-- ============================================================
-- Incremental load flow (how these tables are used together):
--
-- 1. Pipeline starts       -> SP_Pipeline_History logs the run start
-- 2. Lookup_Procurement     -> reads Procurement_Tables and
--                              Watermark_Procurement to get the
--                              list of tables and their last load time
-- 3. ForEach loop            -> processes each table, pulling only
--                              records modified after its stored
--                              watermark
-- 4. On successful load      -> sp_LastModify updates
--                              Watermark_Procurement.Last_Modified_Date
--                              for that table
-- 5. Pipeline ends            -> SP_Pipeline_History logs the run
--                              completion and status
-- ============================================================
