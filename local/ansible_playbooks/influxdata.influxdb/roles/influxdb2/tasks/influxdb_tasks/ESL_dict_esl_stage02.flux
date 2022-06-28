import "influxdata/influxdb/schema"

option task = {name: "ESL_dict_esl_stage02", cron: "30 21 * * *"}

from(bucket: "stage02")
    |> range(start: -1h40m)
    |> filter(fn: (r) => r["_measurement"] == "influxdb_esl_measurement")
    |> schema.fieldsAsCols()
    |> group(columns: ["enum"])
    |> unique(column: "enum")
    |> drop(columns: ["_start", "_stop", "hbtime"])
    |> to(
        bucket: "stage02-dict",
        timeColumn: "_time",
        tagColumns: ["enum"],
        fieldFn: (r) =>
            ({
                "voltage": r.voltage,
                "rfpower": r.rfpower,
                "temp": r.temp,
                "shop": r.shop,
                "apid": r.apid,
                "mac": r.mac,
            }),
    )
