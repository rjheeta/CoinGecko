package Crypto::CoinGecko;
use strict;
use warnings;
use Data::Dumper;
use LWP::UserAgent;
use JSON::XS qw( encode_json decode_json );
use v5.18;

our $VERSION = '1.0';
our $API_VERSION = 'v3';
our $DEBUG = 0;

my $_ua = LWP::UserAgent->new( agent => 'Mozilla/5.0' );
my $_base_url = "https://api.coingecko.com/api/$API_VERSION/";

sub new {
    my $class = shift;
    my $self = bless \(my $ref), $class;
    return $self;
}

sub _request {
    my ($self, $method, $kwargs) = @_;
    
    my $full_url = $_base_url . $method;

    if( $DEBUG ) {
        say "Calling $full_url";
        if( $kwargs ) {
            say "With the following params: " . Dumper($kwargs);
        }
    }

    my $url = URI->new($full_url);
    $url->query_form($kwargs); 
    my $resp = $_ua->get($url);

    die $resp->status_line
        unless( $resp->is_success );

    return decode_json( $resp->decoded_content );
}

# -- Ping --

sub ping {
    my $self = shift;
    return $self->_request("ping");
}

# -- Simple --

sub get_simple_price {
    my ($self, $ids, $currencies, $args) = @_;

    die "Missing IDs" unless($ids);
    die "Missing currencies" unless($currencies);

    $args->{ids} = ref($ids) eq 'ARRAY' ? join(',', @$ids) : $ids;
    $args->{vs_currencies} = ref($currencies) eq 'ARRAY' ? join(',', @$currencies) : $currencies;

    return $self->_request("simple/price", $args);   
}

sub get_simple_token_price_by_id {
    my ($self, $id, $contract_addresses, $currencies, $args) = @_;

    die "Missing IDs" unless($id);
    die "Missing contract addresses" unless($contract_addresses);
    die "Missing currencies" unless($currencies);

    $args->{contract_addresses} = ref($contract_addresses) eq 'ARRAY' ? join(',', @$contract_addresses) : $contract_addresses;
    $args->{vs_currencies} = ref($currencies) eq 'ARRAY' ? join(',', @$currencies) : $currencies;

    return $self->_request("simple/token_price/$id", $args);   
}

sub get_simple_supported_vs_currencies {
    my $self = shift;
    return $self->_request("simple/supported_vs_currencies");
}

# -- Coins --

sub get_coins_list {
    my ($self, $args) = @_;
    return $self->_request("coins/list", $args);
}

sub get_coins_markets {
    my ($self, $currency, $args) = @_;

    die "Missing currency" unless($currency);
    $args->{vs_currency} = $currency;

    return $self->_request("coins/markets", $args);
}

sub get_coin_by_id {
    my ($self, $id) = @_;
    die "Missing ID" unless($id);
    return $self->_request("coins/$id");    
}

sub get_coin_tickers_by_id {
    my ($self, $id, $args) = @_;
    die "Missing ID" unless($id);
    return $self->_request("coins/$id/tickers", $args);    
}

sub get_coin_history_by_id {
    my ($self, $id, $date) = @_;
    die "Missing date" unless($date);   # DD-MM-YYYY format
    return $self->_request("coins/$id/history", {date => $date});    
}

sub get_coin_market_chart_by_id {
    my ($self, $id, $currency, $days, $args) = @_;

    die "Missing IDs" unless($id);
    die "Missing currency" unless($currency);
    die "Missing days" unless($days);

    $args->{vs_currency} = $currency;
    $args->{days} = $days;

    return $self->_request("coins/$id/market_chart", $args);   
}

sub get_coin_market_chart_range_by_id {
    my ($self, $id, $currency, $timestamp_from, $timestamp_to, $args) = @_;

    die "Missing IDs" unless($id);
    die "Missing currency" unless($currency);
    die "Missing timestamp_from date" unless($timestamp_from);
    die "Missing timestamp_tp date" unless($timestamp_to);

    $args->{vs_currency} = $currency;
    $args->{from} = $timestamp_from;
    $args->{to} = $timestamp_to;

    return $self->_request("coins/$id/market_chart/range", $args);   
}

sub get_coin_status_updates_by_id {
    my ($self, $id, $args) = @_;
    die "Missing ID" unless($id);
    return $self->_request("coins/$id/status_updates", $args);    
}

sub get_coin_ohlc_by_id {
    my ($self, $id, $currency, $days) = @_;

    die "Missing IDs" unless($id);
    die "Missing currency" unless($currency);
    die "Missing days" unless($days);

    my $args = {
        vs_currency => $currency,
        days => $days
    };

    return $self->_request("coins/$id/ohlc", $args);    
}

# -- Contracts --

sub get_coin_info_from_contract_address_by_id {
    my ($self, $id, $contract_address) = @_;

    die "Missing IDs" unless($id);
    die "Missing contract address" unless($contract_address);

    return $self->_request("coins/$id/contract/$contract_address", {}); 
}

sub get_coin_market_chart_from_contract_address_by_id {
    my ($self, $id, $contract_address, $currency, $days) = @_;

    die "Missing IDs" unless($id);
    die "Missing contract address" unless($contract_address);
    die "Missing currency" unless($currency);
    die "Missing days" unless($days);

    my $args = {
        vs_currency => $currency,
        days => $days
    };

    return $self->_request("coins/$id/contract/$contract_address/market_chart", $args); 
}

sub get_coin_market_chart_range_from_contract_by_id {
    my ($self, $id, $contract_address, $currency, $timestamp_from, $timestamp_to) = @_;

    die "Missing IDs" unless($id);
    die "Missing contract address" unless($contract_address);
    die "Missing currency" unless($currency);
    die "Missing timestamp_from date" unless($timestamp_from);
    die "Missing timestamp_tp date" unless($timestamp_to);

    my $args = {
        vs_currency => $currency,
        from => $timestamp_from,
        to => $timestamp_to
    };

    return $self->_request("coins/$id/contract/$contract_address/market_chart/range", $args);   
}

# -- Asset platforms --

sub get_asset_platforms {
    my $self = shift;
    return $self->_request("asset_platforms");   
}

# -- Categories

sub get_coins_categories_list {
    my $self = shift;
    return $self->_request("coins/categories/list");   
}

sub get_coins_categories {
    my ($self, $args) = @_;
    return $self->_request("coins/categories", $args);   
}

# -- Exchanges --

sub get_exchanges {
    my ($self, $args) = @_;
    return $self->_request("exchanges", $args);   
}

sub get_exchanges_list {
    my ($self) = @_;
    return $self->_request("exchanges/list");   
}

sub get_exchange_volume_by_id {
    my ($self, $id) = @_;
    die "Missing ID" unless($id);
    return $self->_request("exchanges/$id");   
}

sub get_exchange_tickers_by_id {
    my ($self, $id) = @_;
    die "Missing ID" unless($id);
    return $self->_request("exchanges/$id/tickers");   
}

sub get_exchange_status_updates_by_id {
    my ($self, $id) = @_;
    die "Missing ID" unless($id);
    return $self->_request("exchanges/$id/status_updates");   
}

sub get_exchange_volume_chart_by_id {
    my ($self, $id, $days) = @_;
    die "Missing ID" unless($id);
    die "Missing days" unless($days);

    my $args = {
        days => $days
    };

    return $self->_request("exchanges/$id/volume_chart", $args);   
}

# -- Finance --

sub get_finance_platforms {
    my ($self, $args) = @_;
    return $self->_request("finance_platforms", $args);   
}

sub get_finance_products {
    my ($self, $args) = @_;
    return $self->_request("finance_products", $args);   
}

# -- Indexes --

sub get_indexes {
    my $self = shift;
    return $self->_request("indexes");   
}

sub get_indexes_by_market_id_and_index_id {
    my ($self, $market_id, $id, $args) = @_;
    die "No market ID passed" unless($market_id);
    die "No coin ID passed" unless($id);
    return $self->_request("indexes/$market_id/$id", $args);
}

sub get_indexes_list {
    my $self = shift;
    return $self->_request("indexes/list");   
}

# -- Derivatives --

sub get_derivatives {
    my ($self, $args) = @_;
    return $self->_request("derivatives", $args);   
}

sub get_derivatives_exchanges {
    my ($self, $args) = @_;
    return $self->_request("derivatives/exchanges", $args);   
}

sub get_derivatives_exchanges_by_id {
    my ($self, $id, $args) = @_;
    die "Missing ID" unless($id);
    return $self->_request("derivatives/exchanges/$id", $args);   
}

sub get_derivatives_exchanges_list {
    my $self = shift;
    return $self->_request("derivatives/exchanges/list");   
}

# -- Status updates --

sub get_status_updates {
    my ($self, $args) = @_;

    state $ACCEPTED_TYPES = { coin => 1, market => 1 };
    state $ACCEPTED_CATEGORIES = { 
        general => 1, 
        milestone => 1, 
        partnership => 1, 
        exchange_listing => 1,
        software_release => 1,
        fund_movement => 1,
        new_listings => 1,
        event => 1
    };

    if( $args ) {
        if( $args->{project_type} ) {
            die "Unknown project_type" unless( exists $ACCEPTED_TYPES->{$args->{project_type}});
        }
        if( $args->{category} ) {
            die "Unknown category" unless( exists $ACCEPTED_CATEGORIES->{$args->{category}});
        }
    }

    return $self->_request("status_updates", $args);    
}

# -- Exchange rates --

sub get_exchange_rates {
    my $self = shift;
    return $self->_request("exchange_rates");    
}

# -- Trending -- 

sub get_search_trending {
    my $self = shift;
    return $self->_request("search/trending");   
}

# -- Global --

sub get_global {
    my $self = shift;
    return $self->_request("global");   
}

sub get_global_decentralized_finance_defi {
    my $self = shift;
    return $self->_request("global/decentralized_finance_defi");   
}

# -- Companies -- 

sub get_companies_public_treasury {
    my ($self, $id) = @_;
    die "Missing ID" unless($id);
    return $self->_request("companies/public_treasury/$id");   
}

1;
__END__

=head1 NAME

Crypto::CoinGecko - A wrapper for CoinGecko V3 API

=head1 DESCRIPTION

Refer to the documentation on CoinGecko website (https://www.coingecko.com/api/docs/v3)

Example usage:

    my $cg = Crypto::CoinGecko->new();
    my $r = $cg->get_simple_price("ethereum", "usd");
    Print ("The current price of ETH is: " . $r->{ethereum}->{usd});

=head1 METHODS

=head2 ping

Check API server status

=head2 get_simple_price

Get the current price of any cryptocurrencies in any other supported currencies that you need

    my $r = $cg->get_simple_price("ethereum", "usd");
    Print ("The current price of ETH is: " . $r->{ethereum}->{usd});

=head2 get_simple_token_price_by_id

Get current price of tokens (using contract addresses) for a given platform in any other currency that you need

=head2 get_simple_supported_vs_currencies

Get list of supported_vs_currencies

=head2 get_coins_list

List all supported coins id, name and symbol (no pagination required

=head2 get_coins_markets();

List all supported coins price, market cap, volume, and market related data

=head2 get_coin_by_id;

Get current data (name, price, market, ... including exchange tickers) for a coin

=head2 get_coin_tickers_by_id

Get coin tickers (paginated to 100 items)

=head2 get_coin_history_by_id

Get historical data (name, price, market, stats) at a given date for a coin

=head2 get_coin_market_chart_by_id

Get historical market data include price, market cap, and 24h volume. See API docs for granularity

=head2 get_coin_market_chart_range_by_id

Get historical market data include price, market cap, and 24h volume within a range of timestamp. See API docs for granularity

=head2 get_coin_status_updates_by_id

Get status updates for a given coin (beta)

=head2 get_coin_ohlc_by_id

Get coin's OHLC

=head2 get_coin_info_from_contract_address_by_id

Get coin info from contract address

=head2 get_coin_market_chart_from_contract_address_by_id

Get historical market data include price, market cap, and 24h volume from a contract address. See API docs for granularity

=head2 get_coin_market_chart_range_from_contract_by_id

Get historical market data include price, market cap, and 24h volume within a range of timestamp from a contract address. See API docs for granularity

=head2 get_asset_platforms

List all asset platforms (Blockchain networks)

=head2 get_coins_categories_list

List all categories

=head2 get_coins_categories

List all categories with market data

=head2 get_exchanges

List all exchanges

=head2 get_exchanges_list

List all supported markets id and name (no pagination required)

=head2 get_exchange_volume_by_id

Get exchange volume in BTC and top 100 tickers only

=head2 get_exchange_tickers_by_id

Get exchange tickers (paginated, 100 tickers per page)

=head2 get_exchange_status_updates_by_id

Get status updates for a given exchange (beta)

=head2 get_exchange_volume_chart_by_id

Get volume_chart data for a given exchange (beta)

=head2 get_finance_platforms

List all finance platforms

=head2 get_finance_products

List all finance products

=head2 get_indexes

List all market indexes

=head2 get_indexes_by_market_id_and_index_id

Get market index by market id and index id

=head2 get_indexes_list

List market indexes id and name

=head2 get_derivatives

List all derivative tickers

=head2 get_derivatives_exchanges

List all derivative exchanges

=head2 get_derivatives_exchanges_by_id

Show derivative exchange data

=head2 get_derivatives_exchanges_list

List all derivative exchanges name and identifier

=head2 get_status_updates

List all status_updates with data (description, category, created_at, user, user_title and pin)

=head2 get_exchange_rates

Get BTC-to-Currency exchange rates

=head2 get_search_trending

Get trending search coins (Top-7) on CoinGecko in the last 24 hours

=head2 get_global

Get cryptocurrency global data

=head2 get_global_decentralized_finance_defi

Get cryptocurrency global decentralized finance (defi) data

=head2 get_companies_public_treasury

Get public companies data

=head1 AUTHOR

Randy J

=head1 LICENSE

MIT

=cut