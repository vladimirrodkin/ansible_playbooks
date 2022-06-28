import "influxdata/influxdb/schema"

option task = {name: "ESL_dict_ap_test_bucket", cron: "50 21 * * *"}

from(bucket: "test_bucket")
    |> range(start: -2h)
    |> filter(fn: (r) => r["_measurement"] == "influxdb_ap_measurement")
    |> schema.fieldsAsCols()
    |> group(columns: ["sn"])
    |> unique(column: "sn")
    |> drop(columns: ["_start", "_stop"])
    |> to(
        bucket: "test_bucket-dict",
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
