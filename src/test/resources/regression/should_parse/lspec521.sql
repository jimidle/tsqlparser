-- Create a sample database in which to load the XML schema collection.
CREATE DATABASE SampleDB
GO
USE SampleDB
GO
CREATE XML SCHEMA COLLECTION ManuInstructionsSchemaCollection AS
N'<?xml version="1.0" encoding="UTF-16"?>
<xsd:schema targetNamespace="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelManuInstructions" 
   xmlns          ="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelManuInstructions" 
   elementFormDefault="qualified" 
   attributeFormDefault="unqualified"
   xmlns:xsd="http://www.w3.org/2001/XMLSchema" >

    <xsd:complexType name="StepType" mixed="true" >
        <xsd:choice  minOccurs="0" maxOccurs="unbounded" > 
            <xsd:element name="tool" type="xsd:string" />
            <xsd:element name="material" type="xsd:string" />
            <xsd:element name="blueprint" type="xsd:string" />
            <xsd:element name="specs" type="xsd:string" />
            <xsd:element name="diag" type="xsd:string" />
        </xsd:choice> 
    </xsd:complexType>

    <xsd:element  name="root">
        <xsd:complexType mixed="true">
            <xsd:sequence>
                <xsd:element name="Location" minOccurs="1" maxOccurs="unbounded">
                    <xsd:complexType mixed="true">
                        <xsd:sequence>
                            <xsd:element name="step" type="StepType" minOccurs="1" maxOccurs="unbounded" />
                        </xsd:sequence>
                        <xsd:attribute name="LocationID" type="xsd:integer" use="required"/>
                        <xsd:attribute name="SetupHours" type="xsd:decimal" use="optional"/>
                        <xsd:attribute name="MachineHours" type="xsd:decimal" use="optional"/>
                        <xsd:attribute name="LaborHours" type="xsd:decimal" use="optional"/>
                        <xsd:attribute name="LotSize" type="xsd:decimal" use="optional"/>
                    </xsd:complexType>
                </xsd:element>
            </xsd:sequence>
        </xsd:complexType>
    </xsd:element>
</xsd:schema>' ;
GO
-- Verify - list of collections in the database.
select *
from sys.xml_schema_collections
-- Verify - list of namespaces in the database.
select name
from sys.xml_schema_namespaces

-- Use it. Create a typed xml variable. Note collection name specified.
DECLARE @x xml (ManuInstructionsSchemaCollection)
GO
--Or create a typed xml column.
CREATE TABLE T (
        i int primary key, 
        x xml (ManuInstructionsSchemaCollection))
GO
-- Clean up
DROP TABLE T
GO
DROP XML SCHEMA COLLECTION ManuInstructionsSchemaCollection
Go
USE Master
GO
DROP DATABASE SampleDB
