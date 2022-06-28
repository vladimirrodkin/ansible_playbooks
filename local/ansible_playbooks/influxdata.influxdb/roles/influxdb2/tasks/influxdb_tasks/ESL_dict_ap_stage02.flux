import "influxdata/influxdb/schema"

option task = {name: "ESL_dict_ap_stage02", cron: "50 21 * * *"}

from(bucket: "stage02")
    |> range(start: -2h)
    |> filter(fn: (r) => r["_measurement"] == "influxdb_ap_measurement")
    |> schema.fieldsAsCols()
    |> group(columns: ["sn"])
    |> unique(column: "sn")
    |> drop(columns: ["_start", "_stop"])
    |> to(
        bucket: "stage02-dict",
        timeColumn: "_time",
        tagColumns: ["sn", "hbtime"],
        fieldFn: (r) =>
            ({
                "apid": r.apid,
                "apip": r.apip,
                "descript": r.descript,
                "gateway": r.gateway,
                "mac": r.mac,
                "mode": r.mode,
                "netmask": r.netmask,
                "otime": r.otime,
                "port": r.port,
                "shop": r.shop,
                "status": r.status,
                "version": r.version,
                "wtime": r.wtime,
            }),
    )
