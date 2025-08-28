import { Clarinet, Tx, Chain, Account, types } from 'https://deno.land/x/clarinet@v1.0.0/index.ts';
import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

Clarinet.test({
    name: "Test complete swap functionality",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        const deployer = accounts.get("deployer")!;
        const user1 = accounts.get("wallet_1")!;
        const user2 = accounts.get("wallet_2")!;

        // 1. Check initial token balances
        let block = chain.mineBlock([
            Tx.contractCall("test-token-a", "get-balance", [types.principal(deployer.address)], deployer.address),
            Tx.contractCall("test-token-b", "get-balance", [types.principal(deployer.address)], deployer.address),
        ]);
        
        assertEquals(block.receipts.length, 2);
        assertEquals(block.receipts[0].result, "(ok u1000000000000)");
        assertEquals(block.receipts[1].result, "(ok u1000000000000)");

        // 2. Transfer tokens to users for testing
        block = chain.mineBlock([
            Tx.contractCall("test-token-a", "transfer", [
                types.uint(100000000), // 100 tokens
                types.principal(deployer.address),
                types.principal(user1.address),
                types.none()
            ], deployer.address),
            Tx.contractCall("test-token-b", "transfer", [
                types.uint(200000000), // 200 tokens  
                types.principal(deployer.address),
                types.principal(user1.address),
                types.none()
            ], deployer.address),
        ]);
        
        assertEquals(block.receipts.length, 2);
        assertEquals(block.receipts[0].result, "(ok true)");
        assertEquals(block.receipts[1].result, "(ok true)");

        // 3. Create trading pair with initial liquidity
        block = chain.mineBlock([
            Tx.contractCall("simple-swap", "create-pair", [
                types.principal(`${deployer.address}.test-token-a`),
                types.principal(`${deployer.address}.test-token-b`),
                types.uint(50000000), // 50 TTA
                types.uint(100000000), // 100 TTB (1 TTA = 2 TTB)
            ], user1.address),
        ]);
        
        assertEquals(block.receipts.length, 1);
        assertEquals(block.receipts[0].result.includes("(ok "), true);

        // 4. Check pair reserves
        block = chain.mineBlock([
            Tx.contractCall("simple-swap", "get-pair-reserves", [
                types.principal(`${deployer.address}.test-token-a`),
                types.principal(`${deployer.address}.test-token-b`),
            ], deployer.address),
        ]);
        
        assertEquals(block.receipts.length, 1);
        assertEquals(block.receipts[0].result.includes("reserve-a"), true);

        // 5. Get swap quote
        block = chain.mineBlock([
            Tx.contractCall("simple-swap", "get-swap-quote", [
                types.uint(10000000), // 10 TTA
                types.principal(`${deployer.address}.test-token-a`),
                types.principal(`${deployer.address}.test-token-b`),
            ], deployer.address),
        ]);
        
        assertEquals(block.receipts.length, 1);
        assertEquals(block.receipts[0].result.includes("(ok "), true);

        // 6. Perform swap: TTA -> TTB
        block = chain.mineBlock([
            Tx.contractCall("simple-swap", "swap-exact-tokens-for-tokens", [
                types.uint(5000000), // 5 TTA
                types.uint(9000000), // min 9 TTB (allowing for slippage)
                types.principal(`${deployer.address}.test-token-a`),
                types.principal(`${deployer.address}.test-token-b`),
            ], user1.address),
        ]);
        
        assertEquals(block.receipts.length, 1);
        assertEquals(block.receipts[0].result.includes("(ok "), true);

        // 7. Check balances after swap
        block = chain.mineBlock([
            Tx.contractCall("test-token-a", "get-balance", [types.principal(user1.address)], deployer.address),
            Tx.contractCall("test-token-b", "get-balance", [types.principal(user1.address)], deployer.address),
        ]);
        
        assertEquals(block.receipts.length, 2);
        // User1 should have less TTA and more TTB
        assertEquals(block.receipts[0].result.includes("(ok "), true);
        assertEquals(block.receipts[1].result.includes("(ok "), true);

        // 8. Test reverse swap: TTB -> TTA
        block = chain.mineBlock([
            Tx.contractCall("simple-swap", "swap-exact-tokens-for-tokens", [
                types.uint(10000000), // 10 TTB
                types.uint(4000000), // min 4 TTA (allowing for slippage)
                types.principal(`${deployer.address}.test-token-b`),
                types.principal(`${deployer.address}.test-token-a`),
            ], user1.address),
        ]);
        
        assertEquals(block.receipts.length, 1);
        assertEquals(block.receipts[0].result.includes("(ok "), true);

        // 9. Test add liquidity
        block = chain.mineBlock([
            Tx.contractCall("simple-swap", "add-liquidity", [
                types.principal(`${deployer.address}.test-token-a`),
                types.principal(`${deployer.address}.test-token-b`),
                types.uint(10000000), // 10 TTA desired
                types.uint(20000000), // 20 TTB desired
                types.uint(5000000),  // 5 TTA min
                types.uint(10000000), // 10 TTB min
            ], user1.address),
        ]);
        
        assertEquals(block.receipts.length, 1);
        assertEquals(block.receipts[0].result.includes("(ok "), true);

        // 10. Check LP balance
        block = chain.mineBlock([
            Tx.contractCall("simple-swap", "get-user-lp-balance", [
                types.principal(user1.address),
                types.principal(`${deployer.address}.test-token-a`),
                types.principal(`${deployer.address}.test-token-b`),
            ], deployer.address),
        ]);
        
        assertEquals(block.receipts.length, 1);
        assertEquals(block.receipts[0].result.includes("u"), true);
    },
});

Clarinet.test({
    name: "Test error cases",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        const deployer = accounts.get("deployer")!;
        const user1 = accounts.get("wallet_1")!;

        // 1. Try to swap with identical tokens (should fail)
        let block = chain.mineBlock([
            Tx.contractCall("simple-swap", "swap-exact-tokens-for-tokens", [
                types.uint(5000000), // 5 tokens
                types.uint(4000000), // min 4 tokens
                types.principal(`${deployer.address}.test-token-a`),
                types.principal(`${deployer.address}.test-token-a`), // Same token!
            ], user1.address),
        ]);
        
        assertEquals(block.receipts.length, 1);
        assertEquals(block.receipts[0].result, "(err u1007)"); // ERR_IDENTICAL_TOKENS

        // 2. Try to swap with zero amount (should fail)
        block = chain.mineBlock([
            Tx.contractCall("simple-swap", "swap-exact-tokens-for-tokens", [
                types.uint(0), // 0 tokens
                types.uint(4000000), // min 4 tokens
                types.principal(`${deployer.address}.test-token-a`),
                types.principal(`${deployer.address}.test-token-b`),
            ], user1.address),
        ]);
        
        assertEquals(block.receipts.length, 1);
        assertEquals(block.receipts[0].result, "(err u1006)"); // ERR_ZERO_AMOUNT

        // 3. Try to create pair with identical tokens (should fail)
        block = chain.mineBlock([
            Tx.contractCall("simple-swap", "create-pair", [
                types.principal(`${deployer.address}.test-token-a`),
                types.principal(`${deployer.address}.test-token-a`), // Same token!
                types.uint(50000000),
                types.uint(100000000),
            ], user1.address),
        ]);
        
        assertEquals(block.receipts.length, 1);
        assertEquals(block.receipts[0].result, "(err u1007)"); // ERR_IDENTICAL_TOKENS
    },
});
