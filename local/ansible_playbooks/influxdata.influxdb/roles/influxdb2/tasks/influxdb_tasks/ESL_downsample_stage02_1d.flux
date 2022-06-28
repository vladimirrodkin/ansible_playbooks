import "date"
import "influxdata/influxdb/schema"

option task = {name: "ESL_downsample_stage02_1d", cron: "40 23 * * *"}

from(bucket: "stage02-ds-1h")
    |> range(start: date.truncate(t: -24h, unit: 1h), stop: date.truncate(t: now(), unit: 1h))
    |> filter(fn: (r) => r["_measurement"] == "influxdb_esl_measurement_rfpower")
    |> schema.fieldsAsCols()
    |> group(columns: ["enum"])
    |> aggregateWindow(every: 1d, column: "rfpower", fn: mean, createEmpty: false)
    |> drop(columns: ["_start", "_stop"])
    |> set(key: "_measurement", value: "influxdb_esl_measurement_rfpower")
    |> to(bucket: "stage02-ds-1d", timeColumn: "_time", tagColumns: ["enum"], fieldFn: (r) => ({"rfpower": r.rfpower}))

from(bucket: "stage02-ds-1h")
    |> range(start: date.truncate(t: -24h, unit: 1h), stop: date.truncate(t: now(), unit: 1h))
    |> filter(fn: (r) => r["_measurement"] == "influxdb_esl_measurement_temp")
    |> schema.fieldsAsCols()
    |> group(columns: ["enum"])
    |> aggregateWindow(every: 1d, column: "temp", fn: mean, createEmpty: false)
    |> drop(columns: ["_start", "_stop"])
    |> set(key: "_measurement", value: "influxdb_esl_measurement_temp")
    |> to(bucket: "stage02-ds-1d", timeColumn: "_time", tagColumns: ["enum"], fieldFn: (r) => ({"temp": r.temp}))

from(bucket: "stage02-ds-1h")
    |> range(start: date.truncate(t: -24h, unit: 1h), stop: date.truncate(t: now(), unit: 1h))
    |> filter(fn: (r) => r["_measurement"] == "influxdb_esl_measurement_voltage")
    |> schema.fieldsAsCols()
    |> group(columns: ["enum"])
    |> aggregateWindow(every: 1d, column: "voltage", fn: mean, createEmpty: false)
    |> drop(columns: ["_start", "_stop"])
    |> set(key: "_measurement", value: "influxdb_esl_measurement_voltage")
    |> to(bucket: "stage02-ds-1d", timeColumn: "_time", tagColumns: ["enum"], fieldFn: (r) => ({"voltage": r.voltage}))
