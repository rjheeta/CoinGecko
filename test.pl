use lib 'lib';
use strict;
use warnings;
use Data::Dumper;
use Test::Simple;
use Test::More;
use Crypto::CoinGecko;
use v5.18;

my $r;
my $cg = Crypto::CoinGecko->new();

# --- Ping ---

$r = $cg->ping();
ok( $r->{gecko_says} eq '(V3) To the Moon!', "Ping" );

# --- Simple ---

$r = $cg->get_simple_price("ethereum", "usd");
ok( exists $r->{ethereum}->{usd}, 'get_simple_price');

$r = $cg->get_simple_token_price_by_id('ethereum', '0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2', 'usd');
ok( exists $r->{'0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2'}->{usd}, 'get_simple_token_price_by_id');

$r = $cg->get_simple_supported_vs_currencies();
ok( ref $r eq 'ARRAY', "get_simple_supported_vs_currencies" );

# -- Coins --

$r = $cg->get_coins_list();
ok( grep($_->{symbol} eq 'eth', @$r), "get_coins_list");

$r = $cg->get_coins_markets('usd');
ok( grep($_->{name} eq 'Ethereum', @$r), "get_coins_markets");

$r = $cg->get_coin_by_id('ethereum');
ok( $r->{id} eq 'ethereum', "get_coin_by_id");

$r = $cg->get_coin_tickers_by_id('ethereum');
ok( $r->{name} eq 'Ethereum', "get_coin_tickers_by_id");

$r = $cg->get_coin_history_by_id('ethereum', '01-01-2021');
ok( $r->{id} eq 'ethereum', "get_coin_history_by_id");

$r = $cg->get_coin_market_chart_by_id('ethereum', 'usd', 3);
ok( exists $r->{prices}, "get_coin_market_chart_by_id");

$r = $cg->get_coin_market_chart_range_by_id('ethereum', 'usd', 1610808320, 1611153920);
ok( exists $r->{prices}, "get_coin_market_chart_range_by_id");

$r = $cg->get_coin_status_updates_by_id('ethereum');
ok( exists $r->{status_updates}, "get_coin_status_updates_by_id");

$r = $cg->get_coin_ohlc_by_id('ethereum', 'usd', 7);
ok( ref $r eq 'ARRAY', "get_coin_ohlc_by_id");

# --- Contracts ---

$r = $cg->get_coin_info_from_contract_address_by_id('ethereum', '0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2');
ok( $r->{name} eq 'WETH', "get_coin_info_from_contract_address_by_id");

$r = $cg->get_coin_market_chart_from_contract_address_by_id('ethereum', '0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2', 'usd', 7);
ok( exists $r->{prices}, "get_coin_market_chart_from_contract_address_by_id");

$r = $cg->get_coin_market_chart_range_from_contract_by_id('ethereum', '0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2', 'usd', 1610808320, 1611153920);
ok( exists $r->{prices}, "get_coin_market_chart_range_from_contract_by_id");

# --- Assets ---

$r = $cg->get_asset_platforms();
ok( ref $r eq 'ARRAY', "get_asset_platforms");

# --- Categories ---

$r = $cg->get_coins_categories_list();
ok( ref $r eq 'ARRAY', "get_coins_categories_list");

$r = $cg->get_coins_categories();
ok( ref $r eq 'ARRAY', "get_coins_categories");

# --- Exchanges ---

$r = $cg->get_exchanges();
ok( ref $r eq 'ARRAY', "get_exchanges");

$r = $cg->get_exchanges_list();
ok( ref $r eq 'ARRAY', "get_exchanges_list");

$r = $cg->get_exchange_volume_by_id('binance');
ok( $r->{name} eq 'Binance', "get_exchange_volume_by_id");

$r = $cg->get_exchange_tickers_by_id('binance');
ok( $r->{name} eq 'Binance', "get_exchange_tickers_by_id");

$r = $cg->get_exchange_status_updates_by_id('binance');
ok( exists $r->{status_updates}, "get_exchange_status_updates_by_id");

$r = $cg->get_exchange_volume_chart_by_id('binance', 7);
ok( ref $r eq 'ARRAY', "get_exchange_volume_chart_by_id");

# --- Finance ---

$r = $cg->get_finance_platforms();
ok( ref $r eq 'ARRAY', "get_finance_platforms");

$r = $cg->get_finance_products();
ok( ref $r eq 'ARRAY', "get_finance_products");

# --- Indexes ---

$r = $cg->get_indexes();
ok( ref $r eq 'ARRAY', "get_indexes");

$r = $cg->get_indexes_list();
ok( ref $r eq 'ARRAY', "get_indexes_list");

# -- Derivatives --

$r = $cg->get_derivatives();
ok( ref $r eq 'ARRAY', "get_derivatives");

$r = $cg->get_derivatives_exchanges();
ok( ref $r eq 'ARRAY', "get_derivatives_exchanges");

$r = $cg->get_derivatives_exchanges_by_id('futureswap');
ok( $r->{name} eq 'Futureswap', "get_derivatives_exchanges_by_id");

$r = $cg->get_derivatives_exchanges_list();
ok( ref $r eq 'ARRAY', "get_derivatives_exchanges_list");

# --- Exchange rates ---

$r = $cg->get_exchange_rates();
ok( exists $r->{rates}->{eth}, "get_exchange_rates");

# --- Trending ---

$r = $cg->get_search_trending();
ok( exists $r->{coins}, "get_search_trending");

# --- Global ---

$r = $cg->get_global();
ok( exists $r->{data}, "get_global");

$r = $cg->get_global_decentralized_finance_defi();
ok( exists $r->{data}, "get_global_decentralized_finance_defi");

# --- Companies ---

$r = $cg->get_companies_public_treasury('ethereum');
ok( exists $r->{companies}, "get_companies_public_treasury");

done_testing();

