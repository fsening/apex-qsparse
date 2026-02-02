public class QueryStringParser {
    //region Key Value Logic

    private class KeyValuePair {
        public String key;
        public String value;

        public KeyValuePair(String key, String value) {
            this.key = key;
            this.value = value;
        }
    }

    @TestVisible
    private static Map<String, String> toMap(List<KeyValuePair> keyValuePairs) {
        Map<String, String> result = new Map<String, String>();

        for (KeyValuePair keyValuePair : keyValuePairs) {
            result.put(keyValuePair.key, keyValuePair.value);
        }

        return result;
    }

    //endregion

    //region Parsing Wrapper

    /**
     * Parse a query given as a string argument.
     *
     * @param qs The percent-encoded query string to be parsed.
     *
     * @return Returns a map.
     */
    public static Map<String, String> parse(String qs) {
        return toMap(parseList(qs));
    }

    public static Map<String, String> parse(String qs, Boolean keepBlankValues, Boolean strictParsing, String separator) {
        return toMap(parseList(qs, keepBlankValues, strictParsing, separator));
    }

    @TestVisible
    private static List<KeyValuePair> parseList(String qs) {
        return parseList(qs, false, false, '&');
    }

    //endregion

    //region Parsing Logic

    @TestVisible
    private static List<KeyValuePair> parseList(String qs, Boolean keepBlankValues, Boolean strictParsing, String separator) {
        if (String.isBlank(separator)) {
            throw new IllegalArgumentException('Separator must be non-empty');
        }

        List<KeyValuePair> result = new List<KeyValuePair>();

        if (String.isBlank(qs)) {
            return result;
        }

        for (String keyValue : qs.split(separator)) {
            if (String.isBlank(keyValue) && !strictParsing) {
                continue;
            }

            List<String> kv = keyValue.split('=', 2);

            if (kv.size() != 2) {
                if (strictParsing) {
                    throw new IllegalArgumentException('Bad query field: ' + keyValue);
                }

                // Handle case of a control-name with no equal sign
                if (keepBlankValues) {
                    kv.add('');
                } else {
                    continue;
                }
            }

            String rawName = kv[0];
            String rawValue = kv[1];

            System.debug(':: ' + rawName + ' -> ' + rawValue);

            if (String.isNotBlank(rawName) || keepBlankValues) {
                String name = EncodingUtil.urlDecode(rawName, 'UTF-8');
                String value = EncodingUtil.urlDecode(rawValue, 'UTF-8');

                result.add(new KeyValuePair(name, value));
            }
        }

        return result;
    }

    //endregion
}
