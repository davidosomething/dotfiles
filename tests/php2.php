<?php
namespace MyNs;

class Mine
{

    public $ahlo = "ah";

    /**
     * @param Boolean $something
     */
    public static function someStatic(bool $something) : bool
    {
        return $something;
    }

    public function mem()
    {
        $this->lo = "alo";
    }
}
