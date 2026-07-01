-- ============================================================
-- Database: DB_Procurement (Fabric SQL Database)
-- Purpose: Stored procedures supporting pipeline orchestration
--          and watermark tracking for the ingestion process
-- ============================================================


-- ============================================================
-- Procedure: SP_Pipeline_History
-- Purpose:   Logs the execution history of each pipeline run
--            per source table, including status and timing.
--            Called at the start and end of each pipeline
--            activity to provide a full audit trail of runs.
-- Target:    Pipeline_Execution_History
-- ============================================================
CREATE PROCEDURE SP_Pipeline_History
(
    @Pipeline_Name    VARCHAR(100),
    @Table_Name       VARCHAR(100),
    @Execution_Status VARCHAR(20),
    @Start_Time       DATETIME,
    @End_Time         DATETIME
)
AS
BEGIN
    INSERT INTO Pipeline_Execution_History
    (
        Pipeline_Name,
        Table_Name,
        Execution_Status,
        Start_Time,
        End_Time
    )
    VALUES
    (
        @Pipeline_Name,
        @Table_Name,
        @Execution_Status,
        @Start_Time,
        @End_Time
    );
END;
GO


-- ============================================================
-- Procedure: sp_LastModify
-- Purpose:   Updates the watermark (Last_Modified_Date) for a
--            given source table after a successful load, so
--            the next pipeline run only pulls new or changed
--            records (incremental load pattern).
-- Target:    Procurement_Tables
-- ============================================================
CREATE PROCEDURE sp_LastModify (@Table VARCHAR(100))
AS
BEGIN
    UPDATE Procurement_Tables
    SET Last_Modified_Date = GETDATE()
    WHERE Table_Name = @Table
END;
GO
