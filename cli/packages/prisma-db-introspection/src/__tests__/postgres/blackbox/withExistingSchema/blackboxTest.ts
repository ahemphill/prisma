import * as path from 'path'
import * as fs from 'fs'
import {
  RelationalParser,
  RelationalRenderer,
  RelationalRendererV2,
} from 'prisma-datamodel'

import { Client } from 'pg'
import { connectionDetails } from '../connectionDetails'
import { PostgresConnector } from '../../../../databases/relational/postgres/postgresConnector'
import PostgresDatabaseClient from '../../../../databases/relational/postgres/postgresDatabaseClient'

// Tests are located in different module.
const relativeTestCaseDir = path.join(
  __dirname,
  '../../../../../../prisma-generate-schema/__tests__/blackbox/cases/',
)

export default async function blackBoxTest(name: string) {
  const modelPath = path.join(
    relativeTestCaseDir,
    `${name}/model_relational.graphql`,
  )
  const sqlDumpPath = path.join(relativeTestCaseDir, `${name}/postgres.sql`)

  expect(fs.existsSync(modelPath))
  expect(fs.existsSync(sqlDumpPath))

  const model = fs.readFileSync(modelPath, { encoding: 'UTF-8' })
  const sqlDump = fs.readFileSync(sqlDumpPath, { encoding: 'UTF-8' })

  const parser = new RelationalParser()

  const refModel = parser.parseFromSchemaString(model)

  const client = new Client(connectionDetails)

  const connector = new PostgresConnector(client)

  await client.connect()
  await client.query(
    `DROP SCHEMA IF EXISTS "schema-generator$${name}" cascade;`,
  )
  await client.query(sqlDump)

  const introspectionResult = await connector.introspect(
    `schema-generator$${name}`,
  )

  const unnormalized = introspectionResult.getDatamodel()

  const normalizedWithoutReference = introspectionResult.getNormalizedDatamodel()
  const normalizedWithReference = introspectionResult.getNormalizedDatamodel(
    refModel,
  )

  // Backwards compatible (v1) rendering
  const renderer = new RelationalRenderer()
  const renderedWithReference = renderer.render(normalizedWithReference)

  expect(renderedWithReference).toEqual(model)
  //expect(renderer.render(normalizedWithoutReference)).toMatchSnapshot()
  //expect(renderer.render(unnormalized)).toMatchSnapshot()

  await client.end()

  /*

  const { types } = Parser.create(databaseType).parseFromSchemaString(model)
  const ourSchema = generator.schema.generate(types, {})

  const ourPrintedSchema = printSchema(ourSchema)

  // Write a copy of the generated schema to the FS, for debugging
  fs.writeFileSync(
    path.join(__dirname, `cases/${name}/generated_${databaseType}.graphql`),
    ourPrintedSchema,
    { encoding: 'UTF-8' },
  )

  // Check if our schema equals the prisma schema.
  const prismaSchema = buildSchema(prisma)
  AstTools.assertTypesEqual(prismaSchema, ourSchema, `${name}/${databaseType}`)

  // Check if we can parse the schema we build (e.g. it's syntactically valid).
  parse(ourPrintedSchema)
  */
}

const testNames = fs.readdirSync(relativeTestCaseDir)

for (const testName of testNames) {
  test(`Introspects ${testName}/relational correctly`, async () => {
    await blackBoxTest(testName)
  })
  break
}
