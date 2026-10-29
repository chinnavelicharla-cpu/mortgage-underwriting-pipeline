
{% macro calculate_ltv(loan_amount, property_value) %}

    ROUND(
        ({{ loan_amount }} / NULLIF({{ property_value }}, 0)) * 100,
        2
    )

{% endmacro %}
