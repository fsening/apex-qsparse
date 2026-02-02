@IsTest
private class QueryStringParserTest {
    @IsTest
    private static void testParse() {
        Assert.areEqual(
                new Map<String, String>{
                        'name' => 'John Doe',
                        'phone' => '+919999999999'
                },
                QueryStringParser.parse('name=John+Doe&phone=%2B919999999999')
        );
    }

    @IsTest
    private static void testEmptyQueryString() {
        Assert.areEqual(
                new Map<String, String>{
                },
                QueryStringParser.parse('')
        );
    }

    @IsTest
    private static void testEmptySeparator() {
        try {
            QueryStringParser.parse('', false, false, null);

            Assert.fail('IllegalArgumentException expected');
        } catch (IllegalArgumentException ex) {
            Assert.areEqual('Separator must be non-empty', ex.getMessage());
        }

        try {
            QueryStringParser.parse('', false, false, '');

            Assert.fail('IllegalArgumentException expected');
        } catch (IllegalArgumentException ex) {
            Assert.areEqual('Separator must be non-empty', ex.getMessage());
        }
    }

    @IsTest
    private static void testParseOptions() {
        String qs = 'foo=bar&test';

        Assert.areEqual(
                new Map<String, String>{
                        'foo' => 'bar'
                },
                QueryStringParser.parse(qs, false, false, '&')
        );

        Assert.areEqual(
                new Map<String, String>{
                        'foo' => 'bar',
                        'test' => ''
                },
                QueryStringParser.parse(qs, true, false, '&')
        );

        try {
            QueryStringParser.parse(qs, false, true, '&');

            Assert.fail('IllegalArgumentException expected');
        } catch (IllegalArgumentException ex) {
            Assert.areEqual('Bad query field: test', ex.getMessage());
        }

        try {
            QueryStringParser.parse(qs, true, true, '&');

            Assert.fail('IllegalArgumentException expected');
        } catch (IllegalArgumentException ex) {
            Assert.areEqual('Bad query field: test', ex.getMessage());
        }
    }

    @IsTest
    private static void testParseOptions2() {
        String qs = 'foo=bar&';

        Assert.areEqual(
                new Map<String, String>{
                        'foo' => 'bar'
                },
                QueryStringParser.parse(qs, false, false, '&')
        );

        Assert.areEqual(
                new Map<String, String>{
                        'foo' => 'bar'
                },
                QueryStringParser.parse(qs, true, false, '&')
        );

        Assert.areEqual(
                new Map<String, String>{
                        'foo' => 'bar'
                },
                QueryStringParser.parse(qs, false, true, '&')
        );

        Assert.areEqual(
                new Map<String, String>{
                        'foo' => 'bar'
                },
                QueryStringParser.parse(qs, true, true, '&')
        );
    }
}