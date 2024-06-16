<?php

namespace App\Tests\Controller;

use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;

class DefaultControllerTest extends WebTestCase {
    public function testIndex() {
        $client = static::createClient();

        // Request the route handled by the index method
        $client->request('GET', '/');

        // Assert that the response is successful
        $this->assertResponseIsSuccessful();

        $this->assertSelectorTextContains('h1', 'Hello, Symfony!');
    }
}