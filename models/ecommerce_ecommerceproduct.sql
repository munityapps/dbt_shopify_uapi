{{ config(
    materialized='incremental',
    unique_key='id',
    incremental_strategy='delete+insert',
)}}

SELECT 
    NOW() as created,
    NOW() as modified,
    md5(
      '{{ var("integration_id") }}' ||
      "{{ var("table_prefix") }}_products".id ||
      'product' ||
      'shopify'
    )  as id,
    'shopify' as source,
    '{{ var("integration_id") }}'::uuid  as integration_id,
    _airbyte_raw_{{ var("table_prefix") }}_products._airbyte_data as last_raw_data, 
    '{{ var("timestamp") }}' as sync_timestamp,
    "{{ var("table_prefix") }}_products".id as external_id,
    "{{ var("table_prefix") }}_products".title as name,
    "{{ var("table_prefix") }}_products".body_html as description,
    "{{ var("table_prefix") }}_products".tags as short_description ,
    "{{ var("table_prefix") }}_products_variants".barcode as reference,
    "{{ var("table_prefix") }}_products".product_type as type ,
    NULL as url ,
    "{{ var("table_prefix") }}_products".variants as variations ,
    "{{ var("table_prefix") }}_products_variants".inventory_quantity::float as quantity_available,
    NULL::float as minimal_quantity,
    NULL::float as stock_status ,
    _airbyte_raw_{{ var("table_prefix") }}_products._airbyte_data->'image' as images, 
    TO_JSONB(STRING_TO_ARRAY("{{ var("table_prefix") }}_products".tags, ','))  as tags,
    1::boolean as purchasable,
    NULL::float as regular_price ,
    "{{ var("table_prefix") }}_products_variants".price::float as sale_price,
    "{{ var("table_prefix") }}_products_variants".price::float as price,
    NULL::float  as total_sales ,
    NULL::boolean as on_sale ,
    NULL as rate ,
    "{{ var("table_prefix") }}_products_variants".sku as sku,
    "{{ var("table_prefix") }}_products_variants".admin_graphql_api_id as slug,
    "{{ var("table_prefix") }}_products".status as status ,
    NULL::boolean as virtual ,
    "{{ var("table_prefix") }}_products_variants".weight::float as weight,
    "{{ var("table_prefix") }}_products_variants".barcode as ean13 ,
    NULL::float as height ,
    NULL::float as width ,
    NULL as location ,
    NULL as manufacturer_name ,
    "{{ var("table_prefix") }}_products_variants".weight_unit as unity
FROM "{{ var("table_prefix") }}_products"
LEFT JOIN _airbyte_raw_{{ var("table_prefix") }}_products
ON _airbyte_raw_{{ var("table_prefix") }}_products._airbyte_ab_id = "{{ var("table_prefix") }}_products"._airbyte_ab_id
LEFT JOIN {{ var("table_prefix") }}_products_variants
ON "{{ var("table_prefix") }}_products_variants"._airbyte_{{ var("table_prefix") }}_products_hashid = "{{ var("table_prefix") }}_products"._airbyte_{{ var("table_prefix") }}_products_hashid